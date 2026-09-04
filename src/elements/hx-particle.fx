/**
 * htmFX <hx-particle> Web Component (.fx)
 */

import { Vector3 } from '../core/math.fx';
import { UnitParser } from '../parser/units.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxParticleElement extends HTMLElement {
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['type', 'count', 'color', 'xyz', 'rate', 'speed'];
  }

  connectedCallback(): void {
    this.attach();
  }

  private attach(): void {
    this.viewport = this.closest('hx-viewport') || (document.querySelector('hx-viewport') as HxViewportElement);
    if (!this.viewport || !this.viewport.engine) {
      setTimeout(() => this.attach(), 50);
      return;
    }

    const type = this.getAttribute('type') || 'nebula';
    const count = parseInt(this.getAttribute('count') || '2000', 10);
    const color = UnitParser.parseColor(this.getAttribute('color'), [0.4, 0.6, 1.0, 0.8]);
    const [x, y, z] = UnitParser.parseVec3(this.getAttribute('xyz'), [0, 0, 0]);

    this.viewport.engine.addParticleEmitter(type, count, color, new Vector3(x, y, z));
  }
}
