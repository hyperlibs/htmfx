/**
 * htmFX <hx-camera> Web Component (.fx)
 */

import { CameraMode } from '../core/camera.fx';
import { MacroParser } from '../parser/macro-parser.fx';
import { UnitParser } from '../parser/units.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxCameraElement extends HTMLElement {
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['mode', 'fov', 'xyz', 'target'];
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

    const modeAttr = this.getAttribute('mode') || '$orbit';
    const parsed = MacroParser.parseSingle(modeAttr);
    const mode = (parsed.name || 'orbit') as CameraMode;

    const fov = parseFloat(this.getAttribute('fov') || '60');
    this.viewport.engine.camera.setMode(mode);
    this.viewport.engine.camera.fov = fov;
    this.viewport.engine.camera.updateProjection();

    if (this.hasAttribute('xyz')) {
      const [x, y, z] = UnitParser.parseVec3(this.getAttribute('xyz'));
      this.viewport.engine.camera.position.set(x, y, z);
    }
  }
}
