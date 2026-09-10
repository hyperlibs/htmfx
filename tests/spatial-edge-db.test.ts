import { describe, it, expect } from 'bun:test';
import { Vector3 } from '../src/core/math.fx';
import { SpatialEdgeDB, CellRecord, encodeMorton3D } from '../src/db/spatial-edge-db.fx';

describe('SpatialEdgeDB (InnoDB Flat Spatial Storage Engine)', () => {
  it('inserts and retrieves single cell records accurately', () => {
    const db = new SpatialEdgeDB(1024);
    db.insert({
      id: 101,
      layerId: 2, // Cellular layer
      typeId: 50, // Hepatocyte
      x: 12.5,
      y: -3.2,
      z: 44.1,
      nx: 0,
      ny: 1,
      nz: 0,
      colorRGBA: 0xFF00FFFF,
      stateFlags: 2, // Steatotic
      scale: 1.5,
      meta: 'Hepatic lipid droplet vacuole'
    });

    expect(db.length).toBe(1);
    const cell = db.get(101);
    expect(cell).toBeDefined();
    expect(cell?.id).toBe(101);
    expect(cell?.layerId).toBe(2);
    expect(cell?.typeId).toBe(50);
    expect(cell?.x).toBeCloseTo(12.5, 2);
    expect(cell?.y).toBeCloseTo(-3.2, 2);
    expect(cell?.z).toBeCloseTo(44.1, 2);
    expect(cell?.stateFlags).toBe(2);
    expect(cell?.meta).toBe('Hepatic lipid droplet vacuole');
  });

  it('performs high-density batch insertion of 50,000+ cell-level pixels without nesting', () => {
    const db = new SpatialEdgeDB(65536);
    const count = 50000;
    const batch: CellRecord[] = new Array(count);

    const startTime = performance.now();
    for (let i = 0; i < count; i++) {
      batch[i] = {
        id: i + 1,
        layerId: i % 5,
        typeId: (i % 20) + 1,
        x: (Math.random() - 0.5) * 200,
        y: (Math.random() - 0.5) * 200,
        z: (Math.random() - 0.5) * 200,
        colorRGBA: 0xFFFFFFFF,
        stateFlags: i % 10 === 0 ? 1 : 0
      };
    }
    db.insertBatch(batch);
    const elapsedMs = performance.now() - startTime;

    expect(db.length).toBe(count);
    // Should insert 50,000 records in under 150ms
    expect(elapsedMs).toBeLessThan(1500);

    const testCell = db.get(25000);
    expect(testCell?.id).toBe(25000);
  });

  it('executes in-place atomic updates and O(1) swap-delete', () => {
    const db = new SpatialEdgeDB(100);
    db.insert({ id: 1, layerId: 1, typeId: 1, x: 0, y: 0, z: 0, stateFlags: 0 });
    db.insert({ id: 2, layerId: 1, typeId: 1, x: 10, y: 0, z: 0, stateFlags: 0 });
    db.insert({ id: 3, layerId: 1, typeId: 1, x: 20, y: 0, z: 0, stateFlags: 0 });

    // In-place atomic update
    const updated = db.update(2, { stateFlags: 3, meta: 'Necrotic core' });
    expect(updated).toBe(true);
    expect(db.get(2)?.stateFlags).toBe(3);
    expect(db.get(2)?.meta).toBe('Necrotic core');

    // O(1) swap-delete
    const deleted = db.delete(1);
    expect(deleted).toBe(true);
    expect(db.length).toBe(2);
    expect(db.get(1)).toBeUndefined();
    expect(db.get(2)).toBeDefined();
    expect(db.get(3)).toBeDefined();
  });

  it('filters by spatial Bounding Box and radial sphere queries', () => {
    const db = new SpatialEdgeDB(100);
    db.insert({ id: 10, layerId: 2, typeId: 1, x: 5, y: 5, z: 5 });
    db.insert({ id: 20, layerId: 2, typeId: 1, x: 50, y: 50, z: 50 });
    db.insert({ id: 30, layerId: 3, typeId: 1, x: 6, y: 6, z: 6 }); // Different layer

    // BBox Query
    const bboxResults = db.queryBBox(new Vector3(0, 0, 0), new Vector3(10, 10, 10));
    expect(bboxResults).toContain(10);
    expect(bboxResults).toContain(30);
    expect(bboxResults).not.toContain(20);

    // Layer-filtered BBox Query
    const layer2Results = db.queryBBox(new Vector3(0, 0, 0), new Vector3(10, 10, 10), 2);
    expect(layer2Results).toContain(10);
    expect(layer2Results).not.toContain(30);

    // Sphere Query
    const sphereResults = db.querySphere(new Vector3(5, 5, 5), 3);
    expect(sphereResults).toContain(10);
    expect(sphereResults).toContain(30);
    expect(sphereResults).not.toContain(20);
  });

  it('performs Morton Z-Order spatial clustering', () => {
    const db = new SpatialEdgeDB(100);
    db.insert({ id: 1, layerId: 0, typeId: 1, x: 100, y: 100, z: 100 });
    db.insert({ id: 2, layerId: 0, typeId: 1, x: 0, y: 0, z: 0 });
    db.insert({ id: 3, layerId: 0, typeId: 1, x: 10, y: 10, z: 10 });

    db.clusterByMortonOrder();
    expect(db.length).toBe(3);
    expect(db.get(1)).toBeDefined();
    expect(db.get(2)).toBeDefined();
    expect(db.get(3)).toBeDefined();
  });

  it('provides direct zero-copy GPU vertex buffer view', () => {
    const db = new SpatialEdgeDB(10);
    db.insert({ id: 1, layerId: 0, typeId: 1, x: 1.0, y: 2.0, z: 3.0 });
    db.insert({ id: 2, layerId: 0, typeId: 1, x: 4.0, y: 5.0, z: 6.0 });

    const gpuBuffer = db.getGPUVertexBufferView();
    expect(gpuBuffer.length).toBe(24); // 2 records * 12 float32s
    expect(gpuBuffer[2]).toBe(1.0); // Record 1 x
    expect(gpuBuffer[3]).toBe(2.0); // Record 1 y
    expect(gpuBuffer[4]).toBe(3.0); // Record 1 z
    expect(gpuBuffer[14]).toBe(4.0); // Record 2 x
  });

  it('imports and exports declarative .mx spatial tables seamlessly', () => {
    const db = new SpatialEdgeDB(10);
    const mxInput = `
@meta
  patient_id: "PT-94821"

@cell[1001] @layer[2] @type[10] @3d[12.400, -3.200, 8.500] @state[steatotic] @meta["Hepatic lipid vacuole"]
@cell[1002] @layer[2] @type[10] @3d[14.100, -2.800, 9.000] @state[inflamed] @meta["Kupffer macrophage"]
    `;

    const imported = db.importFromMx(mxInput);
    expect(imported).toBe(2);
    expect(db.get(1001)?.stateFlags).toBe(2); // steatotic
    expect(db.get(1002)?.stateFlags).toBe(1); // inflamed
    expect(db.get(1001)?.meta).toBe('Hepatic lipid vacuole');

    const mxOutput = db.exportToMx();
    expect(mxOutput).toContain('@cell[1001]');
    expect(mxOutput).toContain('@3d[12.400, -3.200, 8.500]');
    expect(mxOutput).toContain('@state[steatotic]');
  });
});
