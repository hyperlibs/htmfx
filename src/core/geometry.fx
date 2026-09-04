/**
 * htmFX Procedural Geometry Generator (.fx)
 */

import { Vector3, AABB } from './math.fx';

export interface GeometryData {
  positions: Float32Array;
  normals: Float32Array;
  uvs: Float32Array;
  indices: Uint16Array | Uint32Array;
  aabb: AABB;
}

export class GeometryBuilder {
  static createBox(width = 1, height = 1, depth = 1): GeometryData {
    const w = width / 2, h = height / 2, d = depth / 2;

    const positions = new Float32Array([
      // Front
      -w, -h,  d,   w, -h,  d,   w,  h,  d,  -w,  h,  d,
      // Back
       w, -h, -d,  -w, -h, -d,  -w,  h, -d,   w,  h, -d,
      // Top
      -w,  h,  d,   w,  h,  d,   w,  h, -d,  -w,  h, -d,
      // Bottom
      -w, -h, -d,   w, -h, -d,   w, -h,  d,  -w, -h,  d,
      // Right
       w, -h,  d,   w, -h, -d,   w,  h, -d,   w,  h,  d,
      // Left
      -w, -h, -d,  -w, -h,  d,  -w,  h,  d,  -w,  h, -d
    ]);

    const normals = new Float32Array([
      // Front
       0,  0,  1,   0,  0,  1,   0,  0,  1,   0,  0,  1,
      // Back
       0,  0, -1,   0,  0, -1,   0,  0, -1,   0,  0, -1,
      // Top
       0,  1,  0,   0,  1,  0,   0,  1,  0,   0,  1,  0,
      // Bottom
       0, -1,  0,   0, -1,  0,   0, -1,  0,   0, -1,  0,
      // Right
       1,  0,  0,   1,  0,  0,   1,  0,  0,   1,  0,  0,
      // Left
      -1,  0,  0,  -1,  0,  0,  -1,  0,  0,  -1,  0,  0
    ]);

    const uvs = new Float32Array([
      0, 0,  1, 0,  1, 1,  0, 1,
      0, 0,  1, 0,  1, 1,  0, 1,
      0, 0,  1, 0,  1, 1,  0, 1,
      0, 0,  1, 0,  1, 1,  0, 1,
      0, 0,  1, 0,  1, 1,  0, 1,
      0, 0,  1, 0,  1, 1,  0, 1
    ]);

    const indices = new Uint16Array([
       0,  1,  2,   0,  2,  3,
       4,  5,  6,   4,  6,  7,
       8,  9, 10,   8, 10, 11,
      12, 13, 14,  12, 14, 15,
      16, 17, 18,  16, 18, 19,
      20, 21, 22,  20, 22, 23
    ]);

    const aabb = new AABB(new Vector3(-w, -h, -d), new Vector3(w, h, d));
    return { positions, normals, uvs, indices, aabb };
  }

  static createSphere(radius = 1, widthSegments = 24, heightSegments = 16): GeometryData {
    const positions: number[] = [];
    const normals: number[] = [];
    const uvs: number[] = [];
    const indices: number[] = [];

    for (let y = 0; y <= heightSegments; y++) {
      const v = y / heightSegments;
      const theta = v * Math.PI;

      for (let x = 0; x <= widthSegments; x++) {
        const u = x / widthSegments;
        const phi = u * Math.PI * 2;

        const sinTheta = Math.sin(theta);
        const cosTheta = Math.cos(theta);
        const sinPhi = Math.sin(phi);
        const cosPhi = Math.cos(phi);

        const nx = sinTheta * cosPhi;
        const ny = cosTheta;
        const nz = sinTheta * sinPhi;

        positions.push(radius * nx, radius * ny, radius * nz);
        normals.push(nx, ny, nz);
        uvs.push(u, 1 - v);
      }
    }

    const rowLength = widthSegments + 1;
    for (let y = 0; y < heightSegments; y++) {
      for (let x = 0; x < widthSegments; x++) {
        const p1 = y * rowLength + x;
        const p2 = p1 + 1;
        const p3 = (y + 1) * rowLength + x;
        const p4 = p3 + 1;

        indices.push(p1, p3, p2);
        indices.push(p2, p3, p4);
      }
    }

    const aabb = new AABB(new Vector3(-radius, -radius, -radius), new Vector3(radius, radius, radius));
    return {
      positions: new Float32Array(positions),
      normals: new Float32Array(normals),
      uvs: new Float32Array(uvs),
      indices: new Uint16Array(indices),
      aabb
    };
  }

  static createCylinder(radiusTop = 1, radiusBottom = 1, height = 2, radialSegments = 24): GeometryData {
    const positions: number[] = [];
    const normals: number[] = [];
    const uvs: number[] = [];
    const indices: number[] = [];

    const halfH = height / 2;

    for (let y = 0; y <= 1; y++) {
      const v = y;
      const r = y === 0 ? radiusTop : radiusBottom;
      const py = y === 0 ? halfH : -halfH;

      for (let x = 0; x <= radialSegments; x++) {
        const u = x / radialSegments;
        const theta = u * Math.PI * 2;

        const sinT = Math.sin(theta);
        const cosT = Math.cos(theta);

        positions.push(r * cosT, py, r * sinT);
        normals.push(cosT, 0, sinT);
        uvs.push(u, v);
      }
    }

    const rowLength = radialSegments + 1;
    for (let x = 0; x < radialSegments; x++) {
      const p1 = x;
      const p2 = p1 + 1;
      const p3 = rowLength + x;
      const p4 = p3 + 1;

      indices.push(p1, p3, p2);
      indices.push(p2, p3, p4);
    }

    const maxR = Math.max(radiusTop, radiusBottom);
    const aabb = new AABB(new Vector3(-maxR, -halfH, -maxR), new Vector3(maxR, halfH, maxR));
    return {
      positions: new Float32Array(positions),
      normals: new Float32Array(normals),
      uvs: new Float32Array(uvs),
      indices: new Uint16Array(indices),
      aabb
    };
  }

  static createPlane(width = 100, depth = 100, widthSegments = 32, depthSegments = 32): GeometryData {
    const positions: number[] = [];
    const normals: number[] = [];
    const uvs: number[] = [];
    const indices: number[] = [];

    const hw = width / 2;
    const hd = depth / 2;

    for (let z = 0; z <= depthSegments; z++) {
      const vz = z / depthSegments;
      const pz = -hd + vz * depth;

      for (let x = 0; x <= widthSegments; x++) {
        const vx = x / widthSegments;
        const px = -hw + vx * width;

        positions.push(px, 0, pz);
        normals.push(0, 1, 0);
        uvs.push(vx, vz);
      }
    }

    const rowLength = widthSegments + 1;
    for (let z = 0; z < depthSegments; z++) {
      for (let x = 0; x < widthSegments; x++) {
        const p1 = z * rowLength + x;
        const p2 = p1 + 1;
        const p3 = (z + 1) * rowLength + x;
        const p4 = p3 + 1;

        indices.push(p1, p3, p2);
        indices.push(p2, p3, p4);
      }
    }

    const aabb = new AABB(new Vector3(-hw, 0, -hd), new Vector3(hw, 0, hd));
    return {
      positions: new Float32Array(positions),
      normals: new Float32Array(normals),
      uvs: new Float32Array(uvs),
      indices: new Uint32Array(indices),
      aabb
    };
  }

  static createTerrain(width = 500, depth = 500, segments = 64, maxHeight = 45, seed = 42): GeometryData {
    const plane = GeometryBuilder.createPlane(width, depth, segments, segments);
    const pos = plane.positions;
    const norms = plane.normals;

    const noise = (x: number, z: number) => {
      const s1 = Math.sin(x * 0.015 + seed) * Math.cos(z * 0.015);
      const s2 = Math.sin(x * 0.04 + z * 0.03) * 0.5;
      const s3 = Math.sin(x * 0.1 - z * 0.08) * 0.25;
      const valley = Math.pow(Math.abs(Math.sin(x * 0.005 + 1.2)), 3.0);
      return (s1 + s2 + s3) * valley * maxHeight;
    };

    let minY = Infinity;
    let maxY = -Infinity;

    for (let i = 0; i < pos.length; i += 3) {
      const x = pos[i];
      const z = pos[i + 2];
      const y = noise(x, z);
      pos[i + 1] = y;

      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }

    const rowLen = segments + 1;
    for (let z = 0; z < segments; z++) {
      for (let x = 0; x < segments; x++) {
        const idx = (z * rowLen + x) * 3;
        const idxRight = (z * rowLen + (x + 1)) * 3;
        const idxDown = ((z + 1) * rowLen + x) * 3;

        const p = new Vector3(pos[idx], pos[idx + 1], pos[idx + 2]);
        const pr = new Vector3(pos[idxRight], pos[idxRight + 1], pos[idxRight + 2]);
        const pd = new Vector3(pos[idxDown], pos[idxDown + 1], pos[idxDown + 2]);

        const v1 = new Vector3().subVectors(pr, p);
        const v2 = new Vector3().subVectors(pd, p);
        const n = new Vector3().crossVectors(v2, v1).normalize();

        norms[idx] = n.x;
        norms[idx + 1] = n.y;
        norms[idx + 2] = n.z;
      }
    }

    plane.aabb.min.y = minY;
    plane.aabb.max.y = maxY;
    return plane;
  }
}
