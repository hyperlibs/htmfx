import { describe, it, expect } from 'vitest';
import { Vector3, Matrix4, Quaternion, Euler, Ray, AABB } from '../src/core/math.fx';

describe('Vector3 Math', () => {
  it('correctly adds, scales, and normalizes vectors', () => {
    const v1 = new Vector3(1, 2, 3);
    const v2 = new Vector3(4, 5, 6);
    v1.add(v2);
    expect(v1.x).toBe(5);
    expect(v1.y).toBe(7);
    expect(v1.z).toBe(9);

    v1.scale(2);
    expect(v1.x).toBe(10);
    expect(v1.y).toBe(14);
    expect(v1.z).toBe(18);

    const unit = new Vector3(0, 3, 4).normalize();
    expect(unit.length()).toBeCloseTo(1.0, 5);
    expect(unit.y).toBeCloseTo(0.6, 5);
    expect(unit.z).toBeCloseTo(0.8, 5);
  });

  it('computes dot and cross products accurately', () => {
    const a = new Vector3(1, 0, 0);
    const b = new Vector3(0, 1, 0);
    expect(a.dot(b)).toBe(0);

    const c = new Vector3().crossVectors(a, b);
    expect(c.x).toBe(0);
    expect(c.y).toBe(0);
    expect(c.z).toBe(1);
  });
});

describe('Matrix4 Transformations', () => {
  it('correctly creates identity and transforms vectors', () => {
    const m = new Matrix4().identity();
    const v = new Vector3(1, 2, 3);
    v.applyMatrix4(m);
    expect(v.x).toBe(1);
    expect(v.y).toBe(2);
    expect(v.z).toBe(3);
  });

  it('inverts matrix transforms correctly', () => {
    const m = new Matrix4();
    m.compose(new Vector3(5, 10, -15), new Quaternion().identity(), new Vector3(2, 2, 2));
    const inv = m.clone().invert();
    const product = new Matrix4().multiplyMatrices(m, inv);
    expect(product.elements[0]).toBeCloseTo(1.0, 4);
    expect(product.elements[5]).toBeCloseTo(1.0, 4);
    expect(product.elements[10]).toBeCloseTo(1.0, 4);
    expect(product.elements[15]).toBeCloseTo(1.0, 4);
  });
});

describe('AABB Bounding Boxes', () => {
  it('correctly detects containment', () => {
    const aabb = new AABB(new Vector3(-5, -5, -5), new Vector3(5, 5, 5));
    expect(aabb.containsPoint(new Vector3(0, 0, 0))).toBe(true);
    expect(aabb.containsPoint(new Vector3(6, 0, 0))).toBe(false);
  });
});
