import { describe, it, expect } from 'vitest';
import { FogField } from '../src/physics/fog-field.fx';
import { Vector3 } from '../src/core/math.fx';

describe('Volumetric Exponential Height Fog Field', () => {
  it('evaluates exponential density equation: ρ(y) = ρ0 * exp(-(y - y0) / H)', () => {
    const fog = new FogField({
      baseDensity: 0.08,
      referenceAltitude: 500.0,
      scaleHeight: 350.0
    });

    // At valley reference altitude y = 500m -> ρ = 0.08
    const valleyDensity = fog.getDensityAtAltitude(500.0);
    expect(valleyDensity).toBeCloseTo(0.08, 4);

    // At mountain peak y = 2000m -> ρ significantly lower
    const peakDensity = fog.getDensityAtAltitude(2000.0);
    expect(peakDensity).toBeLessThan(valleyDensity);
    expect(peakDensity).toBeCloseTo(0.08 * Math.exp(-(2000 - 500) / 350), 4);
  });

  it('analytically integrates optical depth and computes transmittance', () => {
    const fog = new FogField({
      baseDensity: 0.05,
      referenceAltitude: 0,
      scaleHeight: 400.0
    });

    const p1 = new Vector3(0, 0, 0);
    const p2 = new Vector3(0, 200, 500);

    const tau = fog.integrateOpticalDepth(p1, p2);
    expect(tau).toBeGreaterThan(0);

    const transmittance = fog.computeTransmittance(p1, p2);
    expect(transmittance).toBeGreaterThan(0);
    expect(transmittance).toBeLessThan(1);
  });
});
