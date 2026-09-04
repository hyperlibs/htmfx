import { describe, it, expect } from 'vitest';
import { ENV_PRESETS } from '../src/presets/environments.fx';
import { ATMOS_PRESETS } from '../src/presets/atmospheres.fx';
import { BallisticsRK4Solver } from '../src/physics/ballistics-rk4.fx';
import { FogField } from '../src/physics/fog-field.fx';
import { Vector3 } from '../src/core/math.fx';

describe('E2E Spatial Simulation Universe', () => {
  it('verifies all 8 environment presets and parameters', () => {
    const presets = ['space', 'outdoor', 'cyberpunk', 'underwater', 'dungeon', 'desert', 'arctic', 'laboratory'];
    presets.forEach(p => {
      expect(ENV_PRESETS[p]).toBeDefined();
      expect(ENV_PRESETS[p].sunDirection).toBeInstanceOf(Vector3);
      expect(ENV_PRESETS[p].fogDensity).toBeGreaterThanOrEqual(0);
    });
  });

  it('verifies all 9 atmospheric presets', () => {
    const atmos = ['clear', 'cloudy', 'rainy', 'stormy', 'foggy', 'windy', 'snowy', 'sandstorm', 'nebula'];
    atmos.forEach(a => {
      expect(ATMOS_PRESETS[a]).toBeDefined();
      expect(ATMOS_PRESETS[a].fogDensity).toBeGreaterThanOrEqual(0);
    });
  });

  it('verifies seamless supersonic ballistics flight in outdoor foggy atmosphere', () => {
    const fog = new FogField({
      baseDensity: ENV_PRESETS.outdoor.fogDensity,
      scaleHeight: ENV_PRESETS.outdoor.fogScaleHeight,
      referenceAltitude: ENV_PRESETS.outdoor.altitudeM
    });

    const solver = new BallisticsRK4Solver({}, fog);
    const trajectory = solver.solveTrajectory(new Vector3(0, 500, 0), new Vector3(600, 20, 0), 0, 0.05, 5000);

    expect(trajectory.length).toBeGreaterThan(20);
    expect(trajectory[trajectory.length - 1].position.y).toBeLessThanOrEqual(0);
  });
});
