/**
 * htmFX Volumetric Exponential Height Fog Field (.fx)
 * Mathematical Formulation:
 *   ρ(y) = ρ₀ · e^(-(y - y₀) / H)
 */

import { Vector3 } from '../core/math.fx';

export interface FogConfig {
  baseDensity: number;      // ρ₀
  referenceAltitude: number; // y₀ (m)
  scaleHeight: number;      // H (m)
  color: [number, number, number];
  inscatteringExponent: number;
  maxDistance: number;
}

export class FogField {
  config: FogConfig;

  constructor(config?: Partial<FogConfig>) {
    this.config = {
      baseDensity: config?.baseDensity ?? 0.05,
      referenceAltitude: config?.referenceAltitude ?? 0,
      scaleHeight: config?.scaleHeight ?? 400.0,
      color: config?.color ?? [0.7, 0.75, 0.85],
      inscatteringExponent: config?.inscatteringExponent ?? 4.0,
      maxDistance: config?.maxDistance ?? 5000.0
    };
  }

  getDensityAtAltitude(y: number): number {
    const { baseDensity, referenceAltitude, scaleHeight } = this.config;
    const exponent = -(y - referenceAltitude) / scaleHeight;
    const clampedExp = Math.max(-20, Math.min(20, exponent));
    return baseDensity * Math.exp(clampedExp);
  }

  integrateOpticalDepth(p1: Vector3, p2: Vector3): number {
    const { baseDensity, referenceAltitude, scaleHeight, maxDistance } = this.config;
    const dist = Math.min(p1.distanceTo(p2), maxDistance);
    if (dist <= 0.0001) return 0;

    const y1 = p1.y;
    const y2 = p2.y;
    const dy = y2 - y1;

    if (Math.abs(dy) < 0.001) {
      const rho = this.getDensityAtAltitude(y1);
      return rho * dist;
    }

    const exp1 = Math.exp(-(y1 - referenceAltitude) / scaleHeight);
    const exp2 = Math.exp(-(y2 - referenceAltitude) / scaleHeight);
    const integral = (baseDensity * scaleHeight / Math.abs(dy)) * Math.abs(exp1 - exp2);

    return integral * dist;
  }

  computeTransmittance(p1: Vector3, p2: Vector3): number {
    const tau = this.integrateOpticalDepth(p1, p2);
    return Math.exp(-tau);
  }

  applyFog(originalColor: [number, number, number], p1: Vector3, p2: Vector3, sunDir?: Vector3): [number, number, number] {
    const transmittance = this.computeTransmittance(p1, p2);
    const fogFactor = 1.0 - Math.min(1.0, Math.max(0.0, transmittance));

    let [fr, fg, fb] = this.config.color;

    if (sunDir) {
      const rayDir = new Vector3().subVectors(p2, p1).normalize();
      const cosTheta = Math.max(0, rayDir.dot(sunDir.clone().normalize()));
      const phase = Math.pow(cosTheta, this.config.inscatteringExponent) * 0.4;
      fr = Math.min(1.0, fr + phase * 1.0);
      fg = Math.min(1.0, fg + phase * 0.9);
      fb = Math.min(1.0, fb + phase * 0.7);
    }

    const r = originalColor[0] * transmittance + fr * fogFactor;
    const g = originalColor[1] * transmittance + fg * fogFactor;
    const b = originalColor[2] * transmittance + fb * fogFactor;

    return [r, g, b];
  }
}
