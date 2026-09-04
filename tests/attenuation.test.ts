import { describe, it, expect } from 'vitest';
import { AttenuationSolver } from '../src/physics/attenuation.fx';
import { Vector3 } from '../src/core/math.fx';

describe('Inverse-Square Distance Attenuation Solver', () => {
  it('evaluates attenuation equation: I(d) = I0 / (1 + k1*d + k2*d^2)', () => {
    const solver = new AttenuationSolver({
      initialIntensity: 100.0,
      linearFactor: 0.1,
      quadraticFactor: 0.02,
      innerRadius: 0
    });

    const i0 = solver.evaluateAtDistance(0);
    expect(i0).toBe(100.0);

    const i10 = solver.evaluateAtDistance(10);
    // 100 / (1 + 0.1*10 + 0.02*100) = 100 / (1 + 1 + 2) = 100 / 4 = 25.0
    expect(i10).toBeCloseTo(25.0, 3);
  });

  it('computes spatial audio gain and directional pan', () => {
    const solver = new AttenuationSolver();
    const emitter = new Vector3(10, 0, 0); // 10m to the right
    const listener = new Vector3(0, 0, 0);
    const forward = new Vector3(0, 0, -1);
    const right = new Vector3(1, 0, 0);

    const audio = solver.computeSpatialAudio(emitter, listener, forward, right);
    expect(audio.gain).toBeGreaterThan(0);
    expect(audio.pan).toBeCloseTo(1.0, 3); // Fully on the right
  });
});
