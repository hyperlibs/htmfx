/**
 * htmFX Physical Constraints and Joints Kernel (.fx)
 * Distance rods, spring-dampers, ball-and-socket joints, and elastic rope chains.
 */

import { Vector3 } from '../core/math.fx';
import { RigidBody3D } from './rigid-body-3d.fx';

export class PhysicalConstraints {
  /**
   * Distance Constraint (Rigid link maintaining exact distance L)
   */
  static solveDistanceConstraint(
    bodyA: RigidBody3D,
    bodyB: RigidBody3D,
    targetDistance: number,
    stiffness: number = 1.0
  ): void {
    const delta = new Vector3().subVectors(bodyB.position, bodyA.position);
    const currentDist = delta.length();
    if (currentDist < 0.0001) return;

    const difference = (currentDist - targetDistance) / currentDist;
    const totalInvMass = bodyA.invMass + bodyB.invMass;
    if (totalInvMass <= 0) return;

    const correction = delta.scale(0.5 * difference * stiffness);

    if (bodyA.type === 'dynamic') {
      bodyA.position.add(correction.clone().scale(bodyA.invMass / totalInvMass));
    }
    if (bodyB.type === 'dynamic') {
      bodyB.position.sub(correction.clone().scale(bodyB.invMass / totalInvMass));
    }
  }

  /**
   * Elastic Spring-Damper Joint
   */
  static applySpringJoint(
    bodyA: RigidBody3D,
    bodyB: RigidBody3D,
    restLength: number,
    stiffness: number = 50.0,
    damping: number = 2.0
  ): void {
    const delta = new Vector3().subVectors(bodyB.position, bodyA.position);
    const dist = delta.length();
    if (dist < 0.0001) return;

    const dir = delta.clone().normalize();
    const stretch = dist - restLength;
    const springForce = dir.clone().scale(stiffness * stretch);

    const vRel = new Vector3().subVectors(bodyB.velocity, bodyA.velocity);
    const dampingForce = dir.clone().scale(damping * vRel.dot(dir));

    const totalForce = new Vector3().addVectors(springForce, dampingForce);

    bodyA.applyForce(totalForce);
    bodyB.applyForce(totalForce.clone().scale(-1));
  }

  /**
   * Ball-and-Socket Point Anchor Constraint
   */
  static solvePointAnchor(
    body: RigidBody3D,
    anchorWorldPos: Vector3,
    stiffness: number = 1.0
  ): void {
    if (body.type !== 'dynamic') return;
    const delta = new Vector3().subVectors(anchorWorldPos, body.position);
    body.position.add(delta.scale(stiffness));
  }
}
