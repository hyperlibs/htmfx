/**
 * htmFX Spatial Edge DB (InnoDB-inspired Flat Spatial Storage Engine) (.fx)
 * 
 * Provides high-performance, flat, non-nested storage and spatial indexing
 * for 100,000+ to millions of multi-scale cells, voxels, and spatial pixels.
 * 
 * Direct GPU ArrayBuffer compatibility (Zero-Copy WebGPU/WebGL2 Instanced Streams).
 */

import { Vector3, AABB } from '../core/math.fx';

export interface CellRecord {
  id: number;              // Unique Primary Key (uint32)
  layerId: number;         // 0: Organ, 1: Tissue, 2: Cellular, 3: Organelle, 4: Molecular
  typeId: number;          // Biological / Material Taxonomy ID
  x: number;               // 3D Spatial X (float32)
  y: number;               // 3D Spatial Y (float32)
  z: number;               // 3D Spatial Z (float32)
  nx?: number;             // Normal / Orientation X (float32)
  ny?: number;             // Normal / Orientation Y (float32)
  nz?: number;             // Normal / Orientation Z (float32)
  colorRGBA?: number;      // Packed 32-bit color 0xAABBGGRR (uint32)
  stateFlags?: number;     // 0: Normal, 1: Inflamed, 2: Steatotic, 3: Necrotic, 4: Selected
  scale?: number;          // Radius / Bounding scale (float32)
  meta?: string;           // Optional clinical / anatomical metadata string
}

// Fixed 48-byte stride per cell record
export const CELL_STRIDE_BYTES = 48;
export const CELL_STRIDE_FLOATS = CELL_STRIDE_BYTES / 4; // 12 float32s

/**
 * Encodes 3D coordinates into a 30-bit Morton Code (Z-order curve) for spatial clustering.
 */
export function encodeMorton3D(x: number, y: number, z: number, bounds: AABB): number {
  const normX = Math.max(0, Math.min(1023, Math.floor(((x - bounds.min.x) / Math.max(0.0001, bounds.max.x - bounds.min.x)) * 1023)));
  const normY = Math.max(0, Math.min(1023, Math.floor(((y - bounds.min.y) / Math.max(0.0001, bounds.max.y - bounds.min.y)) * 1023)));
  const normZ = Math.max(0, Math.min(1023, Math.floor(((z - bounds.min.z) / Math.max(0.0001, bounds.max.z - bounds.min.z)) * 1023)));

  function expandBits(v: number): number {
    v = (v * 0x00010001) & 0xFF0000FF;
    v = (v * 0x00000101) & 0x0F00F00F;
    v = (v * 0x00000011) & 0xC30C30C3;
    v = (v * 0x00000005) & 0x49249249;
    return v;
  }

  return (expandBits(normX) << 2) | (expandBits(normY) << 1) | expandBits(normZ);
}

/**
 * InnoDB-style High-Density Flat Spatial Storage Engine
 */
export class SpatialEdgeDB {
  private capacity: number;
  private count: number = 0;
  private buffer: ArrayBuffer;
  private floatView: Float32Array;
  private uintView: Uint32Array;
  private uint16View: Uint16Array;
  private uint8View: Uint8Array;

  // Primary Key Index: cell_id -> index offset
  private idIndex: Map<number, number> = new Map();
  // String Metadata Dictionary: cell_id -> string
  private metaStore: Map<number, string> = new Map();
  // Spatial domain bounding box for Morton normalization
  public worldBounds: AABB = new AABB(new Vector3(-500, -500, -500), new Vector3(500, 500, 500));

  constructor(initialCapacity: number = 65536) {
    this.capacity = initialCapacity;
    this.buffer = new ArrayBuffer(this.capacity * CELL_STRIDE_BYTES);
    this.floatView = new Float32Array(this.buffer);
    this.uintView = new Uint32Array(this.buffer);
    this.uint16View = new Uint16Array(this.buffer);
    this.uint8View = new Uint8Array(this.buffer);
  }

  get length(): number {
    return this.count;
  }

  get capacityLimit(): number {
    return this.capacity;
  }

  private ensureCapacity(required: number): void {
    if (required <= this.capacity) return;

    let newCap = this.capacity * 2;
    while (newCap < required) newCap *= 2;

    const newBuffer = new ArrayBuffer(newCap * CELL_STRIDE_BYTES);
    new Uint8Array(newBuffer).set(new Uint8Array(this.buffer));

    this.buffer = newBuffer;
    this.capacity = newCap;
    this.floatView = new Float32Array(this.buffer);
    this.uintView = new Uint32Array(this.buffer);
    this.uint16View = new Uint16Array(this.buffer);
    this.uint8View = new Uint8Array(this.buffer);
  }

  /**
   * Insert a single cell record with flat memory packing.
   */
  insert(cell: CellRecord): void {
    if (this.idIndex.has(cell.id)) {
      this.update(cell.id, cell);
      return;
    }

    this.ensureCapacity(this.count + 1);
    const idx = this.count;
    const baseFloat = idx * CELL_STRIDE_FLOATS;
    const baseUint = idx * CELL_STRIDE_FLOATS;
    const baseUint16 = idx * (CELL_STRIDE_BYTES / 2);

    // Write Primary Key & Headers
    this.uintView[baseUint + 0] = cell.id;
    this.uint16View[baseUint16 + 2] = cell.layerId;
    this.uint16View[baseUint16 + 3] = cell.typeId;

    // Write 3D Spatial Position
    this.floatView[baseFloat + 2] = cell.x;
    this.floatView[baseFloat + 3] = cell.y;
    this.floatView[baseFloat + 4] = cell.z;

    // Write Orientation Normals
    this.floatView[baseFloat + 5] = cell.nx ?? 0.0;
    this.floatView[baseFloat + 6] = cell.ny ?? 1.0;
    this.floatView[baseFloat + 7] = cell.nz ?? 0.0;

    // Write Color & Flags
    this.uintView[baseUint + 8] = cell.colorRGBA ?? 0xFFFFFFFF;
    this.uint16View[baseUint16 + 18] = cell.stateFlags ?? 0;

    // Write Scale
    this.floatView[baseFloat + 10] = cell.scale ?? 1.0;

    // Write Morton Code
    const morton = encodeMorton3D(cell.x, cell.y, cell.z, this.worldBounds);
    this.uintView[baseUint + 11] = morton;

    if (cell.meta) {
      this.metaStore.set(cell.id, cell.meta);
    }

    this.idIndex.set(cell.id, idx);
    this.count++;
  }

  /**
   * Bulk insert for 100,000+ cells in a single zero-allocation pass.
   */
  insertBatch(cells: CellRecord[]): void {
    this.ensureCapacity(this.count + cells.length);
    for (let i = 0; i < cells.length; i++) {
      this.insert(cells[i]);
    }
  }

  /**
   * Fast O(1) retrieval by cell Primary Key.
   */
  get(id: number): CellRecord | undefined {
    const idx = this.idIndex.get(id);
    if (idx === undefined) return undefined;

    const baseFloat = idx * CELL_STRIDE_FLOATS;
    const baseUint = idx * CELL_STRIDE_FLOATS;
    const baseUint16 = idx * (CELL_STRIDE_BYTES / 2);

    return {
      id: this.uintView[baseUint + 0],
      layerId: this.uint16View[baseUint16 + 2],
      typeId: this.uint16View[baseUint16 + 3],
      x: this.floatView[baseFloat + 2],
      y: this.floatView[baseFloat + 3],
      z: this.floatView[baseFloat + 4],
      nx: this.floatView[baseFloat + 5],
      ny: this.floatView[baseFloat + 6],
      nz: this.floatView[baseFloat + 7],
      colorRGBA: this.uintView[baseUint + 8],
      stateFlags: this.uint16View[baseUint16 + 18],
      scale: this.floatView[baseFloat + 10],
      meta: this.metaStore.get(id)
    };
  }

  /**
   * In-place atomic update of cell position, state, or color.
   */
  update(id: number, partial: Partial<CellRecord>): boolean {
    const idx = this.idIndex.get(id);
    if (idx === undefined) return false;

    const baseFloat = idx * CELL_STRIDE_FLOATS;
    const baseUint = idx * CELL_STRIDE_FLOATS;
    const baseUint16 = idx * (CELL_STRIDE_BYTES / 2);

    if (partial.layerId !== undefined) this.uint16View[baseUint16 + 2] = partial.layerId;
    if (partial.typeId !== undefined) this.uint16View[baseUint16 + 3] = partial.typeId;

    let posChanged = false;
    if (partial.x !== undefined) { this.floatView[baseFloat + 2] = partial.x; posChanged = true; }
    if (partial.y !== undefined) { this.floatView[baseFloat + 3] = partial.y; posChanged = true; }
    if (partial.z !== undefined) { this.floatView[baseFloat + 4] = partial.z; posChanged = true; }

    if (posChanged) {
      const curX = this.floatView[baseFloat + 2];
      const curY = this.floatView[baseFloat + 3];
      const curZ = this.floatView[baseFloat + 4];
      this.uintView[baseUint + 11] = encodeMorton3D(curX, curY, curZ, this.worldBounds);
    }

    if (partial.nx !== undefined) this.floatView[baseFloat + 5] = partial.nx;
    if (partial.ny !== undefined) this.floatView[baseFloat + 6] = partial.ny;
    if (partial.nz !== undefined) this.floatView[baseFloat + 7] = partial.nz;
    if (partial.colorRGBA !== undefined) this.uintView[baseUint + 8] = partial.colorRGBA;
    if (partial.stateFlags !== undefined) this.uint16View[baseUint16 + 18] = partial.stateFlags;
    if (partial.scale !== undefined) this.floatView[baseFloat + 10] = partial.scale;
    if (partial.meta !== undefined) this.metaStore.set(id, partial.meta);

    return true;
  }

  /**
   * Delete by ID (Swap-with-last for O(1) removal without memory fragmentation).
   */
  delete(id: number): boolean {
    const idx = this.idIndex.get(id);
    if (idx === undefined) return false;

    const lastIdx = this.count - 1;
    if (idx !== lastIdx) {
      const lastId = this.uintView[lastIdx * CELL_STRIDE_FLOATS];

      // Copy last record to current slot
      const src = new Uint8Array(this.buffer, lastIdx * CELL_STRIDE_BYTES, CELL_STRIDE_BYTES);
      const dst = new Uint8Array(this.buffer, idx * CELL_STRIDE_BYTES, CELL_STRIDE_BYTES);
      dst.set(src);

      // Update index
      this.idIndex.set(lastId, idx);
    }

    this.idIndex.delete(id);
    this.metaStore.delete(id);
    this.count--;
    return true;
  }

  /**
   * Fast Spatial Range Query: Returns array of cell IDs within an Axis-Aligned Bounding Box.
   */
  queryBBox(min: Vector3, max: Vector3, layerIdFilter?: number): number[] {
    const results: number[] = [];
    const minX = min.x, minY = min.y, minZ = min.z;
    const maxX = max.x, maxY = max.y, maxZ = max.z;

    for (let i = 0; i < this.count; i++) {
      const baseFloat = i * CELL_STRIDE_FLOATS;
      const baseUint16 = i * (CELL_STRIDE_BYTES / 2);

      if (layerIdFilter !== undefined && this.uint16View[baseUint16 + 2] !== layerIdFilter) {
        continue;
      }

      const x = this.floatView[baseFloat + 2];
      const y = this.floatView[baseFloat + 3];
      const z = this.floatView[baseFloat + 4];

      if (x >= minX && x <= maxX && y >= minY && y <= maxY && z >= minZ && z <= maxZ) {
        results.push(this.uintView[i * CELL_STRIDE_FLOATS]);
      }
    }

    return results;
  }

  /**
   * Radial Sphere Spatial Query: Returns cell IDs within radius R of center.
   */
  querySphere(center: Vector3, radius: number, layerIdFilter?: number): number[] {
    const results: number[] = [];
    const rSq = radius * radius;
    const cx = center.x, cy = center.y, cz = center.z;

    for (let i = 0; i < this.count; i++) {
      const baseFloat = i * CELL_STRIDE_FLOATS;
      const baseUint16 = i * (CELL_STRIDE_BYTES / 2);

      if (layerIdFilter !== undefined && this.uint16View[baseUint16 + 2] !== layerIdFilter) {
        continue;
      }

      const dx = this.floatView[baseFloat + 2] - cx;
      const dy = this.floatView[baseFloat + 3] - cy;
      const dz = this.floatView[baseFloat + 4] - cz;
      const distSq = dx * dx + dy * dy + dz * dz;

      if (distSq <= rSq) {
        results.push(this.uintView[i * CELL_STRIDE_FLOATS]);
      }
    }

    return results;
  }

  /**
   * Sorts entire flat buffer in-place by 3D Morton Code (Z-order spatial clustering).
   * Ensures physically proximate cells share adjacent L1/L2 cache and GPU vertex pages.
   */
  clusterByMortonOrder(): void {
    if (this.count <= 1) return;

    // Create sorting index pair array [mortonCode, originalSlot]
    const entries: { morton: number; slot: number }[] = new Array(this.count);
    for (let i = 0; i < this.count; i++) {
      entries[i] = {
        morton: this.uintView[i * CELL_STRIDE_FLOATS + 11],
        slot: i
      };
    }

    entries.sort((a, b) => a.morton - b.morton);

    // Reorder buffer into temporary scratch memory
    const scratch = new Uint8Array(this.count * CELL_STRIDE_BYTES);
    const src = new Uint8Array(this.buffer);

    for (let newIdx = 0; newIdx < this.count; newIdx++) {
      const origSlot = entries[newIdx].slot;
      const record = src.subarray(origSlot * CELL_STRIDE_BYTES, (origSlot + 1) * CELL_STRIDE_BYTES);
      scratch.set(record, newIdx * CELL_STRIDE_BYTES);
    }

    src.set(scratch);

    // Rebuild ID index
    this.idIndex.clear();
    for (let i = 0; i < this.count; i++) {
      const id = this.uintView[i * CELL_STRIDE_FLOATS];
      this.idIndex.set(id, i);
    }
  }

  /**
   * Direct Zero-Copy WebGPU / WebGL2 Instanced Vertex Buffer Reference.
   * Feeds GPU draw calls (drawIndexedInstanced) directly from EdgeDB memory.
   */
  getGPUVertexBufferView(): Float32Array {
    return this.floatView.subarray(0, this.count * CELL_STRIDE_FLOATS);
  }

  /**
   * Imports cells directly from declarative .mx spatial table syntax.
   */
  importFromMx(mxContent: string): number {
    const lines = mxContent.split('\n');
    let imported = 0;

    for (const rawLine of lines) {
      const line = rawLine.trim();
      if (!line.startsWith('@cell') && !line.startsWith('@pixel')) continue;

      // Syntax: @cell[10482] @layer[2] @type[101] @3d[12.4, -3.2, 8.5] @state[steatotic] @meta["Hepatocyte lipid vacuole"]
      const idMatch = line.match(/@(cell|pixel)\[(\d+)\]/);
      const layerMatch = line.match(/@layer\[(\d+)\]/);
      const typeMatch = line.match(/@type\[(\d+)\]/);
      const coordMatch = line.match(/@3d\[\s*([\d.-]+)\s*,\s*([\d.-]+)\s*,\s*([\d.-]+)\s*\]/);
      const metaMatch = line.match(/@meta\["([^"]+)"\]/);
      const stateMatch = line.match(/@state\[(\w+)\]/);

      if (idMatch && coordMatch) {
        const id = parseInt(idMatch[2], 10);
        const layerId = layerMatch ? parseInt(layerMatch[1], 10) : 0;
        const typeId = typeMatch ? parseInt(typeMatch[1], 10) : 0;
        const x = parseFloat(coordMatch[1]);
        const y = parseFloat(coordMatch[2]);
        const z = parseFloat(coordMatch[3]);

        let stateFlags = 0;
        if (stateMatch) {
          const s = stateMatch[1].toLowerCase();
          if (s === 'inflamed') stateFlags = 1;
          else if (s === 'steatotic') stateFlags = 2;
          else if (s === 'necrotic') stateFlags = 3;
          else if (s === 'selected') stateFlags = 4;
        }

        this.insert({
          id,
          layerId,
          typeId,
          x,
          y,
          z,
          stateFlags,
          meta: metaMatch ? metaMatch[1] : undefined
        });
        imported++;
      }
    }

    return imported;
  }

  /**
   * Exports EdgeDB content to clean, canonical .mx tabular grammar.
   */
  exportToMx(): string {
    let output = `@meta\n  entity_count: ${this.count}\n  stride_bytes: ${CELL_STRIDE_BYTES}\n\n`;
    output += `# 🧬 Spatial Edge DB Flat Coordinates Table\n\n`;

    for (let i = 0; i < this.count; i++) {
      const cell = this.get(this.uintView[i * CELL_STRIDE_FLOATS]);
      if (!cell) continue;

      const stateStr = cell.stateFlags === 1 ? 'inflamed' : cell.stateFlags === 2 ? 'steatotic' : cell.stateFlags === 3 ? 'necrotic' : 'normal';
      output += `@cell[${cell.id}] @layer[${cell.layerId}] @type[${cell.typeId}] @3d[${cell.x.toFixed(3)}, ${cell.y.toFixed(3)}, ${cell.z.toFixed(3)}] @state[${stateStr}]`;
      if (cell.meta) {
        output += ` @meta["${cell.meta}"]`;
      }
      output += '\n';
    }

    return output;
  }
}
