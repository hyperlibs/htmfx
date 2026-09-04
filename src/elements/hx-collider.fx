/**
 * htmFX <hx-collider> Web Component (.fx)
 * Spatial collision and trigger zones emitting HTMX events.
 */

import { UnitParser } from '../parser/units.fx';
import { Vector3, AABB } from '../core/math.fx';
import { HtmxBridge } from '../htmx/htmx-bridge.fx';

export class HxColliderElement extends HTMLElement {
  aabb: AABB = new AABB();

  static get observedAttributes(): string[] {
    return ['type', 'size', 'xyz', 'trigger'];
  }

  connectedCallback(): void {
    this.updateCollider();
  }

  attributeChangedCallback(): void {
    this.updateCollider();
  }

  updateCollider(): void {
    const [x, y, z] = UnitParser.parseVec3(this.getAttribute('xyz'), [0, 0, 0]);
    const [sx, sy, sz] = UnitParser.parseVec3(this.getAttribute('size'), [2, 2, 2]);
    this.aabb.setFromCenterAndSize(new Vector3(x, y, z), new Vector3(sx, sy, sz));
  }

  checkHit(point: Vector3): boolean {
    this.updateCollider();
    const hit = this.aabb.containsPoint(point);
    if (hit) {
      HtmxBridge.emitSpatialEvent(this, 'spatial:collision', { point });
    }
    return hit;
  }
}
