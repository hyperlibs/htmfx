/**
 * htmFX Spatial Collision and Query Engine (.fx)
 */

import { Vector3, Ray, AABB } from '../core/math.fx';

export interface RaycastHit {
  distance: number;
  point: Vector3;
  normal: Vector3;
  target: any;
}

export class CollisionEngine {
  static rayIntersectsSphere(ray: Ray, center: Vector3, radius: number): RaycastHit | null {
    const oc = new Vector3().subVectors(ray.origin, center);
    const a = ray.direction.dot(ray.direction);
    const b = 2.0 * oc.dot(ray.direction);
    const c = oc.dot(oc) - radius * radius;
    const discriminant = b * b - 4 * a * c;

    if (discriminant < 0) {
      return null;
    }

    const t = (-b - Math.sqrt(discriminant)) / (2.0 * a);
    if (t < 0) {
      const t2 = (-b + Math.sqrt(discriminant)) / (2.0 * a);
      if (t2 < 0) return null;
      const pt = new Vector3().addVectors(ray.origin, ray.direction.clone().scale(t2));
      const norm = new Vector3().subVectors(pt, center).normalize();
      return { distance: t2, point: pt, normal: norm, target: null };
    }

    const hitPoint = new Vector3().addVectors(ray.origin, ray.direction.clone().scale(t));
    const normal = new Vector3().subVectors(hitPoint, center).normalize();
    return { distance: t, point: hitPoint, normal, target: null };
  }

  static rayIntersectsAABB(ray: Ray, aabb: AABB): RaycastHit | null {
    let tmin = (aabb.min.x - ray.origin.x) / (ray.direction.x || 0.00001);
    let tmax = (aabb.max.x - ray.origin.x) / (ray.direction.x || 0.00001);

    if (tmin > tmax) [tmin, tmax] = [tmax, tmin];

    let tymin = (aabb.min.y - ray.origin.y) / (ray.direction.y || 0.00001);
    let tymax = (aabb.max.y - ray.origin.y) / (ray.direction.y || 0.00001);

    if (tymin > tymax) [tymin, tymax] = [tymax, tymin];

    if ((tmin > tymax) || (tymin > tmax)) return null;

    if (tymin > tmin) tmin = tymin;
    if (tymax < tmax) tmax = tymax;

    let tzmin = (aabb.min.z - ray.origin.z) / (ray.direction.z || 0.00001);
    let tzmax = (aabb.max.z - ray.origin.z) / (ray.direction.z || 0.00001);

    if (tzmin > tzmax) [tzmin, tzmax] = [tzmax, tzmin];

    if ((tmin > tzmax) || (tzmin > tmax)) return null;

    if (tzmin > tmin) tmin = tzmin;
    if (tzmax < tmax) tmax = tzmax;

    if (tmin < 0 && tmax < 0) return null;

    const t = tmin >= 0 ? tmin : tmax;
    const hitPoint = new Vector3().addVectors(ray.origin, ray.direction.clone().scale(t));

    const center = new Vector3().addVectors(aabb.min, aabb.max).scale(0.5);
    const halfSize = new Vector3().subVectors(aabb.max, aabb.min).scale(0.5);
    const localHit = new Vector3().subVectors(hitPoint, center);

    const normal = new Vector3();
    const bias = 1.001;
    if (Math.abs(localHit.x) >= halfSize.x / bias) normal.set(Math.sign(localHit.x), 0, 0);
    else if (Math.abs(localHit.y) >= halfSize.y / bias) normal.set(0, Math.sign(localHit.y), 0);
    else if (Math.abs(localHit.z) >= halfSize.z / bias) normal.set(0, 0, Math.sign(localHit.z));
    else normal.set(0, 1, 0);

    return { distance: t, point: hitPoint, normal: normal.normalize(), target: null };
  }

  static sphereIntersectsSphere(c1: Vector3, r1: number, c2: Vector3, r2: number): boolean {
    const dSq = c1.distanceToSquared(c2);
    const radSum = r1 + r2;
    return dSq <= radSum * radSum;
  }
}
