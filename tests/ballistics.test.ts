import { describe, it, expect } from 'vitest';
import { BallisticsRK4Solver } from '../src/physics/ballistics-rk4.fx';
import { Vector3 } from '../src/core/math.fx';

describe('BallisticsRK4Solver', () => {
  it('computes Mach drag coefficient curve correctly', () => {
    const solver = new BallisticsRK4Solver();
    
    const cdSubsonic = solver.getMachDragCoefficient(0.5);
    const cdTransonic = solver.getMachDragCoefficient(1.0);
    const cdSupersonic = solver.getMachDragCoefficient(2.5);

    expect(cdSubsonic).toBeCloseTo(0.295, 3);
    // Transonic wave drag spike
    expect(cdTransonic).toBeGreaterThan(cdSubsonic);
    // Supersonic asymptotic decay
    expect(cdSupersonic).toBeLessThan(cdTransonic);
  });

  it('integrates supersonic trajectory using 4th-Order Runge-Kutta', () => {
    const solver = new BallisticsRK4Solver();
    const startPos = new Vector3(0, 100, 0);
    const startVel = new Vector3(800, 50, 0); // Mach 2.3 launch

    const trajectory = solver.solveTrajectory(startPos, startVel, 0, 0.02, 1000);
    expect(trajectory.length).toBeGreaterThan(10);

    const impact = trajectory[trajectory.length - 1];
    expect(impact.position.y).toBeLessThanOrEqual(0);
    expect(impact.position.x).toBeGreaterThan(0);
  });

  it('evaluates surface ricochet matrices', () => {
    const solver = new BallisticsRK4Solver();
    const vel = new Vector3(500, -20, 0); // Shallow angle (grazing incidence)
    const normal = new Vector3(0, 1, 0);

    const ricochetResult = solver.applyRicochet(vel, normal, {
      normalRestitution: 0.4,
      tangentialFriction: 0.1,
      criticalAngleDeg: 15.0
    });

    expect(ricochetResult.ricocheted).toBe(true);
    expect(ricochetResult.newVelocity.y).toBeGreaterThan(0);
  });
});
