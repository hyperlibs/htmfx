/**
 * htmFX Numerical Integrators Kernel (.fx)
 * Implements Symplectic Euler, Velocity Verlet, RK4, and Harmonic Oscillators.
 */

import { Vector3 } from '../core/math.fx';

export interface PhysicalState {
  position: Vector3;
  velocity: Vector3;
  acceleration: Vector3;
  mass: number;
  restitution: number; // e (0..1)
  friction: number;    // μ
}

export class NumericalIntegrators {
  /**
   * Symplectic (Semi-Implicit) Euler Integrator
   * v(t+dt) = v(t) + a(t) * dt
   * x(t+dt) = x(t) + v(t+dt) * dt
   */
  static stepSymplecticEuler(state: PhysicalState, forces: Vector3, dt: number): void {
    const invMass = state.mass > 0 ? 1 / state.mass : 0;
    state.acceleration = forces.clone().scale(invMass);

    state.velocity.add(state.acceleration.clone().scale(dt));
    state.position.add(state.velocity.clone().scale(dt));
  }

  /**
   * Velocity Verlet Integrator (Energy-conserving symplectic O(dt²))
   * x(t+dt) = x(t) + v(t)*dt + 0.5*a(t)*dt²
   * v(t+dt) = v(t) + 0.5*(a(t) + a(t+dt))*dt
   */
  static stepVelocityVerlet(
    state: PhysicalState,
    computeForcesAt: (pos: Vector3, vel: Vector3) => Vector3,
    dt: number
  ): void {
    const invMass = state.mass > 0 ? 1 / state.mass : 0;
    const aCurrent = state.acceleration.clone();

    // 1. Update position
    state.position.add(state.velocity.clone().scale(dt)).add(aCurrent.clone().scale(0.5 * dt * dt));

    // 2. Compute new acceleration at next position
    const nextForces = computeForcesAt(state.position, state.velocity);
    const aNext = nextForces.scale(invMass);

    // 3. Update velocity
    state.velocity.add(new Vector3().addVectors(aCurrent, aNext).scale(0.5 * dt));
    state.acceleration = aNext;
  }

  /**
   * General 4th-Order Runge-Kutta (RK4) Step for arbitrary state derivatives
   */
  static stepRK4(
    pos: Vector3,
    vel: Vector3,
    accelFn: (p: Vector3, v: Vector3) => Vector3,
    dt: number
  ): { position: Vector3; velocity: Vector3 } {
    // k1
    const p1 = pos.clone();
    const v1 = vel.clone();
    const a1 = accelFn(p1, v1);

    // k2
    const p2 = new Vector3().addVectors(pos, v1.clone().scale(0.5 * dt));
    const v2 = new Vector3().addVectors(vel, a1.clone().scale(0.5 * dt));
    const a2 = accelFn(p2, v2);

    // k3
    const p3 = new Vector3().addVectors(pos, v2.clone().scale(0.5 * dt));
    const v3 = new Vector3().addVectors(vel, a2.clone().scale(0.5 * dt));
    const a3 = accelFn(p3, v3);

    // k4
    const p4 = new Vector3().addVectors(pos, v3.clone().scale(dt));
    const v4 = new Vector3().addVectors(vel, a3.clone().scale(dt));
    const a4 = accelFn(p4, v4);

    const dPos = new Vector3()
      .add(v1)
      .add(v2.clone().scale(2))
      .add(v3.clone().scale(2))
      .add(v4)
      .scale(dt / 6.0);

    const dVel = new Vector3()
      .add(a1)
      .add(a2.clone().scale(2))
      .add(a3.clone().scale(2))
      .add(a4)
      .scale(dt / 6.0);

    return {
      position: new Vector3().addVectors(pos, dPos),
      velocity: new Vector3().addVectors(vel, dVel)
    };
  }

  /**
   * Resolves ground/plane boundary collision with elastomeric restitution (e) and tangential friction (μ)
   */
  static resolvePlaneCollision(
    state: PhysicalState,
    planePoint: Vector3,
    planeNormal: Vector3,
    radius: number = 0.5
  ): boolean {
    const toPlane = new Vector3().subVectors(state.position, planePoint);
    const distToPlane = toPlane.dot(planeNormal);

    if (distToPlane <= radius) {
      // Penetration resolution
      const penetration = radius - distToPlane;
      state.position.add(planeNormal.clone().scale(penetration));

      // Velocity reflection
      const vNorm = state.velocity.dot(planeNormal);
      if (vNorm < 0) {
        const vNormalVec = planeNormal.clone().scale(vNorm);
        const vTangentVec = new Vector3().subVectors(state.velocity, vNormalVec);

        // Restitution e
        const vNormalReflected = vNormalVec.scale(-state.restitution);
        // Friction μ
        const vTangentDamped = vTangentVec.scale(Math.max(0, 1.0 - state.friction));

        state.velocity = new Vector3().addVectors(vNormalReflected, vTangentDamped);
        return true;
      }
    }
    return false;
  }
}
