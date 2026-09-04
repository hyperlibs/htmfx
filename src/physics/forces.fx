/**
 * htmFX Unified Physical Forces Kernel (.fx)
 * Implements Gravity Wells, Stokes Viscous Drag, Buoyancy, Coulomb/Lorentz, and Spring Oscillators.
 */

import { Vector3 } from '../core/math.fx';

export class PhysicsForces {
  /**
   * Gravity Well / N-Body Gravitational Force:
   * F = G * (m1 * m2) / (r² + ε²) * r_hat
   */
  static computeGravityWell(
    pos1: Vector3,
    mass1: number,
    pos2: Vector3,
    mass2: number,
    G: number = 6.6743e-11,
    softeningEpsilon: number = 0.5
  ): Vector3 {
    const rVec = new Vector3().subVectors(pos2, pos1);
    const distSq = rVec.lengthSq();
    const softenedDistSq = distSq + softeningEpsilon * softeningEpsilon;
    const forceMagnitude = (G * mass1 * mass2) / softenedDistSq;

    return rVec.normalize().scale(forceMagnitude);
  }

  /**
   * Stokes Viscous / Aerodynamic Drag Force:
   * F_stokes = -6 * π * η * r * v
   */
  static computeStokesDrag(velocity: Vector3, radius: number, dynamicViscosityEta: number = 1.81e-5): Vector3 {
    const factor = 6.0 * Math.PI * dynamicViscosityEta * radius;
    return velocity.clone().scale(-factor);
  }

  /**
   * Archimedes Buoyant Floatation Force with Surface Damping:
   * F_buoyancy = ρ_fluid * V_submerged * g
   */
  static computeBuoyancy(
    position: Vector3,
    velocity: Vector3,
    radius: number,
    waterLevelY: number = 0,
    fluidDensity: number = 1000.0,
    gravityY: number = 9.80665,
    linearDamping: number = 0.85
  ): Vector3 {
    const bottomY = position.y - radius;
    const topY = position.y + radius;

    if (bottomY >= waterLevelY) {
      // Completely out of water
      return new Vector3(0, 0, 0);
    }

    // Fraction submerged (0..1)
    const submergedDepth = Math.min(2 * radius, Math.max(0, waterLevelY - bottomY));
    const submergedFraction = submergedDepth / (2 * radius);
    const volume = (4.0 / 3.0) * Math.PI * Math.pow(radius, 3);
    const submergedVolume = volume * submergedFraction;

    const buoyantForceY = fluidDensity * submergedVolume * gravityY;
    const dampingForceY = -velocity.y * linearDamping * submergedFraction * 10.0;

    return new Vector3(
      -velocity.x * linearDamping * submergedFraction,
      buoyantForceY + dampingForceY,
      -velocity.z * linearDamping * submergedFraction
    );
  }

  /**
   * Lorentz / Magnetic Force on Charged Particles:
   * F = q * (E + v × B)
   */
  static computeLorentzForce(charge: number, velocity: Vector3, electricField: Vector3, magneticField: Vector3): Vector3 {
    const vCrossB = new Vector3().crossVectors(velocity, magneticField);
    const totalE = new Vector3().addVectors(electricField, vCrossB);
    return totalE.scale(charge);
  }

  /**
   * Damped Harmonic Spring-Damper Force (Hooke's Law):
   * F = -k * (||x - x0|| - restLength) * x_hat - c * v_rel
   */
  static computeSpringDamperForce(
    posA: Vector3,
    velA: Vector3,
    posB: Vector3,
    velB: Vector3,
    restLength: number,
    stiffnessK: number,
    dampingC: number
  ): Vector3 {
    const delta = new Vector3().subVectors(posB, posA);
    const currentLength = delta.length();
    if (currentLength < 0.0001) return new Vector3(0, 0, 0);

    const displacement = currentLength - restLength;
    const springDir = delta.clone().normalize();

    // Spring Force: F_spring = k * (length - restLength) * dir
    const springForce = springDir.clone().scale(stiffnessK * displacement);

    // Damping Force: F_damping = c * (v_rel . dir) * dir
    const vRel = new Vector3().subVectors(velB, velA);
    const vRelProj = vRel.dot(springDir);
    const dampingForce = springDir.clone().scale(dampingC * vRelProj);

    return new Vector3().addVectors(springForce, dampingForce);
  }
}
