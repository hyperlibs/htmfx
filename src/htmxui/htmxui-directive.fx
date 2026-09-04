/**
 * htmFX htmxUI Directives & Signals Companion Bridge (.fx)
 * Registers HTMXUI.directive('3d', ...) and synchronizes with HxBolt reactive tickers.
 */

import { Engine } from '../core/engine.fx';
import { MacroParser } from '../parser/macro-parser.fx';
import { UnitParser } from '../parser/units.fx';

export class HtmxUIDirective {
  private static registered = false;

  static register(): void {
    if (this.registered) return;
    this.registered = true;

    const win = window as any;

    // Direct registration with HTMXUI if loaded
    if (win.HTMXUI && typeof win.HTMXUI.directive === 'function') {
      win.HTMXUI.directive('3d', (el: HTMLElement, binding: any) => {
        HtmxUIDirective.mount(el, binding);
      });
    }

    // Direct registration with HxBolt signals and tickers
    if (win.HxBolt && typeof win.HxBolt.ticker === 'function') {
      win.HxBolt.ticker.subscribe((timestamp: number, dt: number) => {
        // Broadcast tick to all active hx-viewport elements
        const viewports = document.querySelectorAll('hx-viewport');
        viewports.forEach((vp: any) => {
          if (vp.engine && vp.engine.isRunning) {
            // Engine runs its own RAF loop or can sync with HxBolt frame
          }
        });
      });
    }
  }

  static mount(el: HTMLElement, binding: any): void {
    const value = binding?.value || binding?.expression;
    if (!value) return;

    // If applied on a canvas or container, treat as viewport
    if (el.tagName.toLowerCase() === 'canvas' || el.classList.contains('spatial-host')) {
      const parsed = MacroParser.parseDirectives(value);
      for (const m of parsed.macros) {
        if (m.name.startsWith('env_') || m.name === 'space' || m.name === 'outdoor' || m.name === 'cyberpunk') {
          el.setAttribute('3denv', `$${m.name}`);
        } else if (m.name === 'orbit' || m.name === 'first_person' || m.name === 'cinematic') {
          el.setAttribute('3dcamera', `$${m.name}`);
        } else {
          el.setAttribute('3datmos', `$${m.name}`);
        }
      }
    } else {
      // Applied on an entity element, parse xyz or rotation
      const coords = UnitParser.parseVec3(value);
      el.setAttribute('xyz', `${coords[0]}, ${coords[1]}, ${coords[2]}`);
    }
  }
}
