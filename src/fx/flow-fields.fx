/**
 * htmFX 3D Vector Flow Fields Kernel (.fx)
 * Divergence-free Curl Noise, Perlin vortices, sink/source attractors, and aerodynamic wind shears.
 */

import { Vector3 } from '../core/math.fx';

export class FlowFields {
  /**
   * Evaluates divergence-free 3D Curl Noise vector at point p
   * Curl(F) = ∇ × F
   */
  static computeCurlNoise(p: Vector3, time: number = 0, scale: number = 0.05, speed: number = 0.5): Vector3 {
    const eps = 0.001;
    const t = time * speed;

    const n1 = (x: number, y: number, z: number) => Math.sin(x * scale + t) * Math.cos(y * scale) + Math.sin(z * scale);
    const n2 = (x: number, y: number, z: number) => Math.cos(x * scale) * Math.sin(y * scale + t) - Math.cos(z * scale);
    const n3 = (x: number, y: number, z: number) => Math.sin(x * scale - t) * Math.cos(z * scale) + Math.sin(y * scale);

    // Partial derivatives
    const dy_n3 = (n3(p.x, p.y + eps, p.z) - n3(p.x, p.y - eps, p.z)) / (2 * eps);
    const dz_n2 = (n2(p.x, p.y, p.z + eps) - n2(p.x, p.y, p.z - eps)) / (2 * eps);

    const dz_n1 = (n1(p.x, p.y, p.z + eps) - n1(p.x, p.y, p.z - eps)) / (2 * eps);
    const dx_n3 = (n3(p.x + eps, p.y, p.z) - n3(p.x - eps, p.y, p.z)) / (2 * eps);

    const dx_n2 = (n2(p.x + eps, p.y, p.z) - n2(p.x - eps, p.y, p.z)) / (2 * eps);
    const dy_n1 = (n1(p.x, p.y + eps, p.z) - n1(p.x, p.y - eps, p.z)) / (2 * eps);

    return new Vector3(
      dy_n3 - dz_n2,
      dz_n1 - dx_n3,
      dx_n2 - dy_n1
    );
  }

  /**
   * Evaluates a 3D Vortex / Cyclone Field around an axis
   */
  static computeVortexField(
    pos: Vector3,
    center: Vector3,
    axis: Vector3 = new Vector3(0, 1, 0),
    swirlStrength: number = 10.0,
    inwardAttraction: number = 2.0,
    upwardBuoyancy: number = 4.0
  ): Vector3 {
    const toCenter = new Vector3().subVectors(center, pos);
    const r = toCenter.length();
    if (r < 0.01) return new Vector3(0, upwardBuoyancy, 0);

    // Tangential rotational velocity = axis × r_vec
    const tangent = new Vector3().crossVectors(axis, toCenter).normalize().scale(swirlStrength / Math.max(1.0, r * 0.2));
    const radial = toCenter.normalize().scale(inwardAttraction);
    const vertical = axis.clone().scale(upwardBuoyancy);

    return new Vector3()
      .add(tangent)
      .add(radial)
      .add(vertical);
  }
}
