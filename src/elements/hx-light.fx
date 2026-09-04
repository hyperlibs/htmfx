/**
 * htmFX <hx-light> Web Component (.fx)
 */

import { UnitParser } from '../parser/units.fx';
import { Vector3 } from '../core/math.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxLightElement extends HTMLElement {
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['type', 'direction', 'intensity', 'color', 'xyz'];
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

    const type = this.getAttribute('type') || 'sun';
    const intensity = parseFloat(this.getAttribute('intensity') || '1.0');
    const color = UnitParser.parseColor(this.getAttribute('color'), [1, 1, 1, 1]);

    if (type === 'sun' || type === 'directional') {
      const [dx, dy, dz] = UnitParser.parseVec3(this.getAttribute('direction'), [1, -2, 1]);
      this.viewport.engine.sunDirection = new Vector3(dx, dy, dz).normalize();
      this.viewport.engine.sunColor = [color[0] * intensity, color[1] * intensity, color[2] * intensity];
    } else if (type === 'ambient') {
      this.viewport.engine.ambientLight = [color[0] * intensity * 0.3, color[1] * intensity * 0.3, color[2] * intensity * 0.3];
    }
  }
}
