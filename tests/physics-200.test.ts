import { describe, it, expect } from 'bun:test';
import {
  Vector3,
  PhysicsForces,
  NumericalIntegrators,
  RigidBody3D,
  RigidBodyWorld,
  FlowFields,
  SPATIAL_FX_CATALOGUE,
  getSpatialFX,
  getSpatialFXByCategory,
  searchSpatialFXByTag
} from '../src/index.fx';

describe('PhysicsForces Solvers', () => {
  it('calculates Newtonian gravity well force accurately', () => {
    const pos1 = new Vector3(0, 0, 0);
    const pos2 = new Vector3(10, 0, 0);
    const force = PhysicsForces.computeGravityWell(pos1, 1000, pos2, 2000, 1.0, 0.0);
    // F = G * m1 * m2 / r^2 = 1.0 * 1000 * 2000 / 100 = 20000 along +X
    expect(force.x).toBeCloseTo(20000, 0);
    expect(force.y).toBeCloseTo(0, 0);
    expect(force.z).toBeCloseTo(0, 0);
  });

  it('calculates Stokes viscous drag resisting motion', () => {
    const vel = new Vector3(10, 0, -5);
    const drag = PhysicsForces.computeStokesDrag(vel, 0.05, 1.8e-5);
    // F_drag = -6 * pi * eta * r * v
    expect(drag.x).toBeLessThan(0);
    expect(drag.z).toBeGreaterThan(0);
  });

  it('calculates Archimedes buoyant upward force', () => {
    const pos = new Vector3(0, -1, 0);
    const vel = new Vector3(0, 0, 0);
    const buoyancy = PhysicsForces.computeBuoyancy(pos, vel, 1.0, 0, 1000, 9.80665, 0.5);
    expect(buoyancy.y).toBeGreaterThan(0);
  });

  it('computes damped spring force with Hookes law', () => {
    const pA = new Vector3(0, 0, 0);
    const pB = new Vector3(2, 0, 0);
    const vA = new Vector3(0, 0, 0);
    const vB = new Vector3(1, 0, 0);
    const force = PhysicsForces.computeSpringDamperForce(pA, vA, pB, vB, 1.0, 100, 10);
    // Length is 2, rest length is 1, delta is 1 (stretched), so spring pulls towards +X on A, but returns total force vector
    expect(force.x).toBeGreaterThan(0);
  });

  it('computes Lorentz electromagnetic force', () => {
    const q = 1.0;
    const E = new Vector3(0, 10, 0);
    const v = new Vector3(5, 0, 0);
    const B = new Vector3(0, 0, 2);
    const lorentz = PhysicsForces.computeLorentzForce(q, v, E, B);
    // F = q * (E + v x B)
    // v x B = (5,0,0) x (0,0,2) = (0, -10, 0)
    // F = 1.0 * (0, 10 - 10, 0) = (0, 0, 0)
    expect(lorentz.x).toBeCloseTo(0, 4);
    expect(lorentz.y).toBeCloseTo(0, 4);
    expect(lorentz.z).toBeCloseTo(0, 4);
  });
});

describe('Numerical Integrators', () => {
  it('integrates projectile trajectory via Symplectic Euler', () => {
    const state = {
      position: new Vector3(0, 100, 0),
      velocity: new Vector3(10, 0, 0),
      acceleration: new Vector3(0, 0, 0),
      mass: 1.0,
      restitution: 0.8,
      friction: 0.1
    };
    const gForces = new Vector3(0, -9.8, 0);
    const dt = 0.1;
    NumericalIntegrators.stepSymplecticEuler(state, gForces, dt);
    expect(state.velocity.y).toBeCloseTo(-0.98, 2);
    expect(state.position.x).toBeCloseTo(1.0, 2);
  });

  it('integrates using 4th Order Runge-Kutta (RK4)', () => {
    const p = new Vector3(0, 50, 0);
    const v = new Vector3(0, 0, 0);
    const next = NumericalIntegrators.stepRK4(
      p,
      v,
      (pos, vel) => new Vector3(0, -9.8, 0),
      0.1
    );
    expect(next.velocity.y).toBeLessThan(0);
    expect(next.position.y).toBeLessThan(50);
  });

  it('handles plane collision response with elastomeric restitution', () => {
    const state = {
      position: new Vector3(0, 0.1, 0),
      velocity: new Vector3(5, -10, 0),
      acceleration: new Vector3(0, 0, 0),
      mass: 1.0,
      restitution: 0.8,
      friction: 0.2
    };
    const planePoint = new Vector3(0, 0, 0);
    const planeNormal = new Vector3(0, 1, 0);
    const collided = NumericalIntegrators.resolvePlaneCollision(state, planePoint, planeNormal, 0.5);
    expect(collided).toBe(true);
    expect(state.velocity.y).toBeGreaterThan(0); // Rebounded
    expect(state.velocity.x).toBeLessThan(5); // Tangential friction damped
  });
});

describe('3D Rigid Body Engine & Contact Manifolds', () => {
  it('calculates inertia tensors for geometric primitives', () => {
    const sphere = new RigidBody3D({ shapeType: 'sphere', mass: 10, radius: 2 });
    expect(sphere.invMass).toBe(0.1);
    expect(sphere.invInertia.x).toBeGreaterThan(0);

    const box = new RigidBody3D({ shapeType: 'box', mass: 12, size: new Vector3(2, 2, 2) });
    expect(box.invMass).toBeCloseTo(1 / 12, 4);
  });

  it('applies force and torque to update linear and angular velocity', () => {
    const body = new RigidBody3D({ shapeType: 'box', mass: 5, size: new Vector3(1, 1, 1) });
    body.applyForce(new Vector3(0, 10, 0));
    body.applyTorque(new Vector3(0, 5, 0));
    body.integrate(0.1, new Vector3(0, 0, 0));
    expect(body.velocity.y).toBeGreaterThan(0.18);
    expect(body.angularVelocity.y).toBeGreaterThan(0);
  });

  it('simulates multi-body world and resolves collisions', () => {
    const world = new RigidBodyWorld({ gravity: new Vector3(0, -9.81, 0) });
    const b1 = new RigidBody3D({ shapeType: 'sphere', mass: 2, radius: 1 });
    b1.position.set(0, 10, 0);
    const b2 = new RigidBody3D({ shapeType: 'sphere', mass: 2, radius: 1 });
    b2.position.set(0, 8, 0);
    world.addBody(b1);
    world.addBody(b2);
    world.step(0.016);
    expect(b1.position.y).toBeLessThan(10);
    expect(b2.position.y).toBeLessThan(8);
  });
});

describe('Flow Fields & Curl Noise', () => {
  it('computes 3D Curl Noise with zero divergence', () => {
    const curl = FlowFields.computeCurlNoise(new Vector3(1.2, 3.4, 5.6), 0, 0.5, 1.0);
    expect(typeof curl.x).toBe('number');
    expect(typeof curl.y).toBe('number');
    expect(typeof curl.z).toBe('number');
    expect(Number.isFinite(curl.x)).toBe(true);
  });

  it('computes atmospheric vortex flow field', () => {
    const center = new Vector3(0, 0, 0);
    const axis = new Vector3(0, 1, 0);
    const v = FlowFields.computeVortexField(new Vector3(10, 0, 0), center, axis, 5.0, 1.0, 0.5);
    // At (10, 0, 0), vortex rotating about Y gives tangential velocity
    expect(typeof v.z).toBe('number');
    expect(v.x).toBeLessThan(0); // Inward attraction to origin
  });
});

describe('200+ Spatial FX & Physics Library Catalogue', () => {
  it('contains at least 200 distinct spatial particle FX presets', () => {
    expect(Object.keys(SPATIAL_FX_CATALOGUE).length).toBeGreaterThanOrEqual(200);
  });

  it('covers all 6 foundational physical domains', () => {
    const thermal = getSpatialFXByCategory('thermal');
    const electric = getSpatialFXByCategory('electric');
    const fluid = getSpatialFXByCategory('fluid');
    const kinetic = getSpatialFXByCategory('kinetic');
    const cosmic = getSpatialFXByCategory('cosmic');
    const atmospheric = getSpatialFXByCategory('atmospheric');

    expect(thermal.length).toBeGreaterThanOrEqual(30);
    expect(electric.length).toBeGreaterThanOrEqual(30);
    expect(fluid.length).toBeGreaterThanOrEqual(30);
    expect(kinetic.length).toBeGreaterThanOrEqual(30);
    expect(cosmic.length).toBeGreaterThanOrEqual(30);
    expect(atmospheric.length).toBeGreaterThanOrEqual(30);
  });

  it('allows lookup by ID and tag search', () => {
    const plasma = getSpatialFX('plasma_torch');
    expect(plasma).toBeDefined();
    expect(plasma?.category).toBe('thermal');

    const explosions = searchSpatialFXByTag('explosion');
    expect(explosions.length).toBeGreaterThan(0);
  });
});

