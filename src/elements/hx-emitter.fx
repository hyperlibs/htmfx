/**
 * htmFX <hx-emitter> Web Component (.fx)
 * Dynamic point/volume physics particle emitter ($burn, $flare, $radiate, $splash, $explode, $zap, $slime, $wave)
 */

import { Vector3 } from '../core/math.fx';
import { UnitParser } from '../parser/units.fx';
import { MacroParser } from '../parser/macro-parser.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxEmitterElement extends HTMLElement {
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['type', 'rate', 'velocity', 'xyz', 'color'];
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

    const rawType = this.getAttribute('type') || '$burn';
    const parsedMacro = MacroParser.parseSingle(rawType);
    const emitterType = parsedMacro.name || 'burn';

    const count = parseInt(this.getAttribute('rate') || '500', 10);
    const [x, y, z] = UnitParser.parseVec3(this.getAttribute('xyz'), [0, 0, 0]);

    let defaultColor: [number, number, number, number] = [1.0, 0.4, 0.1, 0.9];
    if (emitterType === 'zap') defaultColor = [0.1, 0.9, 1.0, 0.95];
    else if (emitterType === 'slime') defaultColor = [0.2, 0.95, 0.2, 0.85];
    else if (emitterType === 'explode') defaultColor = [1.0, 0.8, 0.2, 0.95];
    else if (emitterType === 'splash') defaultColor = [0.3, 0.7, 1.0, 0.75];

    const color = UnitParser.parseColor(this.getAttribute('color'), defaultColor);

    this.viewport.engine.addParticleEmitter(emitterType, count, color, new Vector3(x, y, z));
  }
}
