/**
 * htmFX Supersonic Ballistics & Altitude Drag Solver (RK4 Integrator) (.fx)
 * Mathematical Formulation:
 *   F_drag = -0.5 · ρ(y) · C_d(Mach) · A · ||v_rel|| · v_rel
 *   a(t, r, v) = g + F_drag / m
 */

import { Vector3 } from '../core/math.fx';
import { FogField } from './fog-field.fx';

export interface ProjectileConfig {
  massKg: number;
  crossSectionAreaM2: number;
  referenceCd: number;
  speedOfSoundMs: number;
}

export interface BallisticsState {
  position: Vector3;
  velocity: Vector3;
  time: number;
}

export interface RicochetMatrix {
  normalRestitution: number;
  tangentialFriction: number;
  criticalAngleDeg: number;
}

export class BallisticsRK4Solver {
  projectile: ProjectileConfig;
  gravity: Vector3;
  fogField: FogField;
  windShear: (altitude: number) => Vector3;

  constructor(projectile?: Partial<ProjectileConfig>, fogField?: FogField) {
    this.projectile = {
      massKg: projectile?.massKg ?? 0.045,
      crossSectionAreaM2: projectile?.crossSectionAreaM2 ?? 0.00015,
      referenceCd: projectile?.referenceCd ?? 0.295,
      speedOfSoundMs: projectile?.speedOfSoundMs ?? 343.0
    };
    this.gravity = new Vector3(0, -9.80665, 0);
    this.fogField = fogField ?? new FogField({ baseDensity: 1.225, scaleHeight: 8500.0 });
    
    this.windShear = (alt: number) => {
      const speed = Math.min(35.0, 5.0 + Math.log10(Math.max(1, alt + 10)) * 4.0);
      return new Vector3(speed, 0, 0);
    };
  }

  getMachDragCoefficient(mach: number): number {
    const base = this.projectile.referenceCd;
    if (mach < 0.75) {
      return base;
    } else if (mach >= 0.75 && mach <= 1.05) {
      const t = (mach - 0.75) / 0.3;
      return base + (0.58 - base) * (3 * t * t - 2 * t * t * t);
    } else if (mach > 1.05 && mach <= 1.5) {
      const t = (mach - 1.05) / 0.45;
      return 0.58 - 0.12 * t;
    } else {
      return Math.max(base * 1.1, 0.46 / Math.sqrt(Math.max(0.1, mach * mach - 1.0)));
    }
  }

  computeAcceleration(pos: Vector3, vel: Vector3): Vector3 {
    const wind = this.windShear(pos.y);
    const vRel = new Vector3().subVectors(vel, wind);
    const speedRel = vRel.length();

    if (speedRel < 0.0001) {
      return this.gravity.clone();
    }

    const mach = speedRel / this.projectile.speedOfSoundMs;
    const cd = this.getMachDragCoefficient(mach);
    const rho = this.fogField.getDensityAtAltitude(pos.y);

    const dragMagnitude = 0.5 * rho * cd * this.projectile.crossSectionAreaM2 * speedRel * speedRel;
    const dragDir = vRel.clone().normalize().scale(-1);
    const fDrag = dragDir.scale(dragMagnitude);

    const aDrag = fDrag.scale(1 / this.projectile.massKg);
    return new Vector3().addVectors(this.gravity, aDrag);
  }

  stepRK4(state: BallisticsState, dt: number): BallisticsState {
    const r0 = state.position.clone();
    const v0 = state.velocity.clone();

    // k1
    const dr1 = v0.clone();
    const dv1 = this.computeAcceleration(r0, v0);

    // k2
    const r1 = new Vector3().addVectors(r0, dr1.clone().scale(dt * 0.5));
    const v1 = new Vector3().addVectors(v0, dv1.clone().scale(dt * 0.5));
    const dr2 = v1.clone();
    const dv2 = this.computeAcceleration(r1, v1);

    // k3
    const r2 = new Vector3().addVectors(r0, dr2.clone().scale(dt * 0.5));
    const v2 = new Vector3().addVectors(v0, dv2.clone().scale(dt * 0.5));
    const dr3 = v2.clone();
    const dv3 = this.computeAcceleration(r2, v2);

    // k4
    const r3 = new Vector3().addVectors(r0, dr3.clone().scale(dt));
    const v3 = new Vector3().addVectors(v0, dv3.clone().scale(dt));
    const dr4 = v3.clone();
    const dv4 = this.computeAcceleration(r3, v3);

    const dR = new Vector3()
      .add(dr1)
      .add(dr2.clone().scale(2))
      .add(dr3.clone().scale(2))
      .add(dr4)
      .scale(dt / 6.0);

    const dV = new Vector3()
      .add(dv1)
      .add(dv2.clone().scale(2))
      .add(dv3.clone().scale(2))
      .add(dv4)
      .scale(dt / 6.0);

    return {
      position: new Vector3().addVectors(r0, dR),
      velocity: new Vector3().addVectors(v0, dV),
      time: state.time + dt
    };
  }

  solveTrajectory(initialPos: Vector3, initialVel: Vector3, groundY: number = 0, dt: number = 0.016, maxSteps: number = 10000): BallisticsState[] {
    const trajectory: BallisticsState[] = [{
      position: initialPos.clone(),
      velocity: initialVel.clone(),
      time: 0
    }];

    let current: BallisticsState = trajectory[0];

    for (let i = 0; i < maxSteps; i++) {
      current = this.stepRK4(current, dt);
      trajectory.push({
        position: current.position.clone(),
        velocity: current.velocity.clone(),
        time: current.time
      });

      if (current.position.y <= groundY) {
        break;
      }
    }

    return trajectory;
  }

  applyRicochet(velocity: Vector3, normal: Vector3, matrix: RicochetMatrix): { ricocheted: boolean; newVelocity: Vector3 } {
    const norm = normal.clone().normalize();
    const speed = velocity.length();
    if (speed < 0.1) {
      return { ricocheted: false, newVelocity: new Vector3(0, 0, 0) };
    }

    const incDir = velocity.clone().normalize();
    const cosAngle = -incDir.dot(norm);
    const incidentAngleDeg = 90 - (Math.acos(Math.max(-1, Math.min(1, cosAngle))) * 180 / Math.PI);

    if (incidentAngleDeg <= matrix.criticalAngleDeg && cosAngle > 0) {
      const vNormal = norm.clone().scale(velocity.dot(norm));
      const vTangent = new Vector3().subVectors(velocity, vNormal);

      const vNormalReflected = vNormal.scale(-matrix.normalRestitution);
      const vTangentDamped = vTangent.scale(1.0 - matrix.tangentialFriction);

      const newVel = new Vector3().addVectors(vNormalReflected, vTangentDamped);
      return { ricocheted: true, newVelocity: newVel };
    }

    return { ricocheted: false, newVelocity: new Vector3(0, 0, 0) };
  }
}
