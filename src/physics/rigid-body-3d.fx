/**
 * htmFX 3D Rigid Body Dynamics Kernel (.fx)
 * Inspired by Cannon.js / Matter.js: Full 6-DOF impulse resolution, inertia tensors, and contact manifolds.
 */

import { Vector3, Quaternion, Matrix4, AABB } from '../core/math.fx';

export type BodyType = 'dynamic' | 'static' | 'kinematic';
export type ShapeType = 'sphere' | 'box' | 'plane';

export interface ContactManifold {
  bodyA: RigidBody3D;
  bodyB: RigidBody3D;
  contactPoint: Vector3;
  contactNormal: Vector3; // Points from A to B
  penetrationDepth: number;
}

export class RigidBody3D {
  id: string;
  type: BodyType;
  shapeType: ShapeType;
  radius: number;
  halfExtents: Vector3;

  position: Vector3;
  velocity: Vector3;
  force: Vector3;

  quaternion: Quaternion;
  angularVelocity: Vector3; // ω
  torque: Vector3;

  mass: number;
  invMass: number;
  inertia: Vector3;        // Diagonal principal inertia
  invInertia: Vector3;

  restitution: number;     // e
  friction: number;        // μ
  linearDamping: number;
  angularDamping: number;

  constructor(options?: {
    id?: string;
    type?: BodyType;
    shapeType?: ShapeType;
    mass?: number;
    radius?: number;
    size?: Vector3;
    restitution?: number;
    friction?: number;
  }) {
    this.id = options?.id || `body-${Math.random().toString(36).substr(2, 7)}`;
    this.type = options?.type || 'dynamic';
    this.shapeType = options?.shapeType || 'sphere';
    this.radius = options?.radius || 1.0;
    this.halfExtents = options?.size ? options.size.clone().scale(0.5) : new Vector3(1, 1, 1);

    this.position = new Vector3(0, 0, 0);
    this.velocity = new Vector3(0, 0, 0);
    this.force = new Vector3(0, 0, 0);

    this.quaternion = new Quaternion();
    this.angularVelocity = new Vector3(0, 0, 0);
    this.torque = new Vector3(0, 0, 0);

    this.mass = this.type === 'static' ? 0 : (options?.mass || 1.0);
    this.invMass = this.mass > 0 ? 1.0 / this.mass : 0;

    this.restitution = options?.restitution ?? 0.4;
    this.friction = options?.friction ?? 0.2;
    this.linearDamping = 0.99;
    this.angularDamping = 0.98;

    this.inertia = new Vector3(1, 1, 1);
    this.invInertia = new Vector3(1, 1, 1);
    this.updateInertiaTensor();
  }

  updateInertiaTensor(): void {
    if (this.mass <= 0) {
      this.inertia.set(0, 0, 0);
      this.invInertia.set(0, 0, 0);
      return;
    }

    if (this.shapeType === 'sphere') {
      const i = 0.4 * this.mass * this.radius * this.radius;
      this.inertia.set(i, i, i);
      this.invInertia.set(1 / i, 1 / i, 1 / i);
    } else if (this.shapeType === 'box') {
      const w2 = 4 * this.halfExtents.x * this.halfExtents.x;
      const h2 = 4 * this.halfExtents.y * this.halfExtents.y;
      const d2 = 4 * this.halfExtents.z * this.halfExtents.z;

      const ix = (1 / 12) * this.mass * (h2 + d2);
      const iy = (1 / 12) * this.mass * (w2 + d2);
      const iz = (1 / 12) * this.mass * (w2 + h2);

      this.inertia.set(ix, iy, iz);
      this.invInertia.set(1 / ix, 1 / iy, 1 / iz);
    }
  }

  applyForce(f: Vector3): void {
    if (this.type !== 'dynamic') return;
    this.force.add(f);
  }

  applyTorque(t: Vector3): void {
    if (this.type !== 'dynamic') return;
    this.torque.add(t);
  }

  applyForceAtPoint(f: Vector3, worldPoint: Vector3): void {
    if (this.type !== 'dynamic') return;
    this.force.add(f);
    const r = new Vector3().subVectors(worldPoint, this.position);
    const t = new Vector3().crossVectors(r, f);
    this.torque.add(t);
  }

  applyImpulse(impulse: Vector3, contactVector: Vector3): void {
    if (this.type !== 'dynamic') return;
    this.velocity.add(impulse.clone().scale(this.invMass));
    const deltaL = new Vector3().crossVectors(contactVector, impulse);
    this.angularVelocity.add(new Vector3(
      deltaL.x * this.invInertia.x,
      deltaL.y * this.invInertia.y,
      deltaL.z * this.invInertia.z
    ));
  }

  integrate(dt: number, gravity: Vector3 = new Vector3(0, -9.80665, 0)): void {
    if (this.type !== 'dynamic') return;

    // Linear
    const totalAccel = new Vector3().addVectors(gravity, this.force.clone().scale(this.invMass));
    this.velocity.add(totalAccel.scale(dt));
    this.velocity.scale(Math.pow(this.linearDamping, dt * 60));
    this.position.add(this.velocity.clone().scale(dt));

    // Angular
    const angularAccel = new Vector3(
      this.torque.x * this.invInertia.x,
      this.torque.y * this.invInertia.y,
      this.torque.z * this.invInertia.z
    );
    this.angularVelocity.add(angularAccel.scale(dt));
    this.angularVelocity.scale(Math.pow(this.angularDamping, dt * 60));

    // Quaternion integration: q_next = q + 0.5 * dt * ω * q
    const halfDt = 0.5 * dt;
    const wx = this.angularVelocity.x * halfDt;
    const wy = this.angularVelocity.y * halfDt;
    const wz = this.angularVelocity.z * halfDt;

    const qx = this.quaternion.x, qy = this.quaternion.y, qz = this.quaternion.z, qw = this.quaternion.w;
    this.quaternion.x += wx * qw + wy * qz - wz * qy;
    this.quaternion.y += wy * qw + wz * qx - wx * qz;
    this.quaternion.z += wz * qw + wx * qy - wy * qx;
    this.quaternion.w += -wx * qx - wy * qy - wz * qz;

    // Normalize quaternion
    const qLen = Math.sqrt(
      this.quaternion.x * this.quaternion.x +
      this.quaternion.y * this.quaternion.y +
      this.quaternion.z * this.quaternion.z +
      this.quaternion.w * this.quaternion.w
    );
    if (qLen > 0.00001) {
      this.quaternion.x /= qLen;
      this.quaternion.y /= qLen;
      this.quaternion.z /= qLen;
      this.quaternion.w /= qLen;
    }

    // Reset accumulators
    this.force.set(0, 0, 0);
    this.torque.set(0, 0, 0);
  }
}

export class RigidBodyWorld {
  bodies: RigidBody3D[] = [];
  gravity: Vector3 = new Vector3(0, -9.80665, 0);

  addBody(body: RigidBody3D): void {
    this.bodies.push(body);
  }

  step(dt: number): void {
    // 1. Integrate motion
    for (const b of this.bodies) {
      b.integrate(dt, this.gravity);
    }

    // 2. Detect and resolve contacts
    const manifolds = this.detectCollisions();
    for (const m of manifolds) {
      this.resolveContact(m);
    }
  }

  private detectCollisions(): ContactManifold[] {
    const manifolds: ContactManifold[] = [];

    for (let i = 0; i < this.bodies.length; i++) {
      for (let j = i + 1; j < this.bodies.length; j++) {
        const a = this.bodies[i];
        const b = this.bodies[j];

        if (a.type === 'static' && b.type === 'static') continue;

        if (a.shapeType === 'sphere' && b.shapeType === 'sphere') {
          const delta = new Vector3().subVectors(b.position, a.position);
          const dist = delta.length();
          const radiusSum = a.radius + b.radius;

          if (dist < radiusSum && dist > 0.0001) {
            const normal = delta.clone().normalize();
            const penetration = radiusSum - dist;
            const contactPoint = new Vector3().addVectors(a.position, normal.clone().scale(a.radius - penetration * 0.5));

            manifolds.push({
              bodyA: a,
              bodyB: b,
              contactPoint,
              contactNormal: normal,
              penetrationDepth: penetration
            });
          }
        }
      }
    }

    return manifolds;
  }

  private resolveContact(m: ContactManifold): void {
    const { bodyA, bodyB, contactNormal, penetrationDepth, contactPoint } = m;

    // Positional separation (Baumgarte stabilization)
    const totalInvMass = bodyA.invMass + bodyB.invMass;
    if (totalInvMass <= 0) return;

    const separationRatioA = bodyA.invMass / totalInvMass;
    const separationRatioB = bodyB.invMass / totalInvMass;

    bodyA.position.sub(contactNormal.clone().scale(penetrationDepth * separationRatioA));
    bodyB.position.add(contactNormal.clone().scale(penetrationDepth * separationRatioB));

    // Impulse computation
    const rA = new Vector3().subVectors(contactPoint, bodyA.position);
    const rB = new Vector3().subVectors(contactPoint, bodyB.position);

    const vPointA = new Vector3().addVectors(bodyA.velocity, new Vector3().crossVectors(bodyA.angularVelocity, rA));
    const vPointB = new Vector3().addVectors(bodyB.velocity, new Vector3().crossVectors(bodyB.angularVelocity, rB));
    const vRel = new Vector3().subVectors(vPointB, vPointA);

    const vRelNorm = vRel.dot(contactNormal);
    if (vRelNorm > 0) return; // Moving apart

    const e = Math.min(bodyA.restitution, bodyB.restitution);

    // Rotational inertia terms: (r x n) * I^-1 x r . n
    const rAxN = new Vector3().crossVectors(rA, contactNormal);
    const rBxN = new Vector3().crossVectors(rB, contactNormal);

    const termA = new Vector3(
      rAxN.x * bodyA.invInertia.x,
      rAxN.y * bodyA.invInertia.y,
      rAxN.z * bodyA.invInertia.z
    ).cross(rA).dot(contactNormal);

    const termB = new Vector3(
      rBxN.x * bodyB.invInertia.x,
      rBxN.y * bodyB.invInertia.y,
      rBxN.z * bodyB.invInertia.z
    ).cross(rB).dot(contactNormal);

    const impulseMag = -(1 + e) * vRelNorm / (totalInvMass + termA + termB);
    const impulse = contactNormal.clone().scale(impulseMag);

    bodyA.applyImpulse(impulse.clone().scale(-1), rA);
    bodyB.applyImpulse(impulse, rB);
  }
}
