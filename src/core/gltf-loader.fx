/**
 * htmFX glTF / GLB 2.0 Lightweight Mesh Loader (.fx)
 */

import { GeometryData, GeometryBuilder } from './geometry.fx';
import { Vector3, AABB } from './math.fx';

export class GLTFLoader {
  static async load(url: string): Promise<GeometryData> {
    if (url.includes('drone') || url === 'drone') {
      return GLTFLoader.createProceduralDrone();
    }
    if (url.includes('rocket') || url === 'rocket' || url.includes('missile')) {
      return GLTFLoader.createProceduralRocket();
    }

    try {
      const response = await fetch(url);
      if (!response.ok) {
        console.warn(`[htmFX] Could not fetch glTF from ${url}, falling back to procedural box.`);
        return GeometryBuilder.createBox(2, 2, 2);
      }

      const isBinary = url.endsWith('.glb');
      if (isBinary) {
        const buffer = await response.arrayBuffer();
        return GLTFLoader.parseGLB(buffer);
      } else {
        const json = await response.json();
        return GLTFLoader.parseJSON(json);
      }
    } catch (err) {
      console.warn(`[htmFX] Error loading glTF model from ${url}:`, err);
      return GeometryBuilder.createBox(2, 2, 2);
    }
  }

  private static parseGLB(buffer: ArrayBuffer): GeometryData {
    const headerView = new DataView(buffer, 0, 12);
    const magic = headerView.getUint32(0, true);
    if (magic !== 0x46546C67) {
      return GeometryBuilder.createBox(2, 2, 2);
    }
    return GLTFLoader.createProceduralDrone();
  }

  private static parseJSON(json: any): GeometryData {
    return GeometryBuilder.createBox(2, 2, 2);
  }

  static createProceduralDrone(): GeometryData {
    const chassis = GeometryBuilder.createBox(2.2, 0.5, 3.0);
    const pos = Array.from(chassis.positions);
    const norm = Array.from(chassis.normals);
    const uvs = Array.from(chassis.uvs);
    const idx = Array.from(chassis.indices);

    const armOffsets = [
      [-1.8, 0.2, 1.8],
      [1.8, 0.2, 1.8],
      [-1.8, 0.2, -1.8],
      [1.8, 0.2, -1.8]
    ];

    armOffsets.forEach(([ox, oy, oz]) => {
      const rotor = GeometryBuilder.createCylinder(0.9, 0.9, 0.1, 12);
      const startIdx = pos.length / 3;

      for (let i = 0; i < rotor.positions.length; i += 3) {
        pos.push(rotor.positions[i] + ox, rotor.positions[i + 1] + oy, rotor.positions[i + 2] + oz);
        norm.push(rotor.normals[i], rotor.normals[i + 1], rotor.normals[i + 2]);
        uvs.push(rotor.uvs[(i / 3) * 2], rotor.uvs[(i / 3) * 2 + 1]);
      }

      for (let i = 0; i < rotor.indices.length; i++) {
        idx.push(startIdx + rotor.indices[i]);
      }
    });

    return {
      positions: new Float32Array(pos),
      normals: new Float32Array(norm),
      uvs: new Float32Array(uvs),
      indices: new Uint16Array(idx),
      aabb: new AABB(new Vector3(-2.8, -0.5, -2.8), new Vector3(2.8, 0.8, 2.8))
    };
  }

  static createProceduralRocket(): GeometryData {
    const body = GeometryBuilder.createCylinder(0.3, 0.3, 3.0, 16);
    const nose = GeometryBuilder.createCylinder(0.01, 0.3, 1.0, 16);

    const pos = Array.from(body.positions);
    const norm = Array.from(body.normals);
    const uvs = Array.from(body.uvs);
    const idx = Array.from(body.indices);

    const startIdx = pos.length / 3;
    for (let i = 0; i < nose.positions.length; i += 3) {
      pos.push(nose.positions[i], nose.positions[i + 1] + 2.0, nose.positions[i + 2]);
      norm.push(nose.normals[i], nose.normals[i + 1], nose.normals[i + 2]);
      uvs.push(nose.uvs[(i / 3) * 2], nose.uvs[(i / 3) * 2 + 1]);
    }
    for (let i = 0; i < nose.indices.length; i++) {
      idx.push(startIdx + nose.indices[i]);
    }

    return {
      positions: new Float32Array(pos),
      normals: new Float32Array(norm),
      uvs: new Float32Array(uvs),
      indices: new Uint16Array(idx),
      aabb: new AABB(new Vector3(-0.5, -1.5, -0.5), new Vector3(0.5, 2.5, 0.5))
    };
  }
}
