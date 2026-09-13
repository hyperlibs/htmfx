/**
 * htmFX htmxUI Directives & Signals Companion Bridge (.fx)
 * Registers HTMXUI.directive('3d', ...) and synchronizes with HxBolt reactive tickers.
 */

import { Engine } from '../core/engine.fx';
import { MacroParser } from '../parser/macro-parser.fx';
import { UnitParser } from '../parser/units.fx';

export class HtmxUIDirective {
  private static registered = false;
  private static activeEngines = new Set<Engine>();

  static registerEngine(engine: Engine): void {
    this.activeEngines.add(engine);
  }

  static unregisterEngine(engine: Engine): void {
    this.activeEngines.delete(engine);
  }

  static register(): void {
    if (this.registered) return;
    this.registered = true;

    const win = window as any;

    // Direct registration with HTMXUI directive pipeline
    if (win.HTMXUI && typeof win.HTMXUI.directive === 'function') {
      win.HTMXUI.directive('3d', (el: HTMLElement, binding: any) => {
        HtmxUIDirective.mount(el, binding);
      });
    }

    // Direct registration with HxBolt 120 FPS reactive ticker
    if (win.HxBolt && typeof win.HxBolt.ticker === 'function') {
      win.HxBolt.ticker.subscribe((timestamp: number, dt: number) => {
        // 1. Tick all registered standalone active engines
        HtmxUIDirective.activeEngines.forEach(engine => {
          if (engine.isRunning) {
            engine.tick(dt, timestamp);
          }
        });

        // 2. Tick active <hx-viewport> engines
        try {
          const viewports = document.querySelectorAll('hx-viewport');
          viewports.forEach((vp: any) => {
            if (vp.engine && vp.engine.isRunning) {
              vp.engine.tick(dt, timestamp);
            }
          });
        } catch {
          // Safe fallback if querySelectorAll fails
        }
      });
    }
  }

  /**
   * Mounts 3D spatial directives or initializes standalone canvas elements.
   * Supports [\\33 denv], [\\33 datmos], [\\33 dcamera], and [\\33 dfx] attributes safely.
   */
  static mount(el: HTMLElement, binding?: any): Engine | null {
    const value = typeof binding === 'string' ? binding : (binding?.value || binding?.expression || (typeof el.getAttribute === 'function' ? el.getAttribute('hx-3d') : '') || '');
    const isCanvas = el.tagName?.toLowerCase() === 'canvas';
    const isSpatialHost = Boolean(el.classList?.contains?.('spatial-host') || (typeof el.hasAttribute === 'function' && el.hasAttribute('hx-3d')));

    if (isCanvas) {
      // Direct Canvas Mount (e.g. from app-universe.html)
      const canvasEl = el as HTMLCanvasElement;
      let engine = (canvasEl as any).__htmfx_engine as Engine | undefined;

      if (!engine) {
        engine = new Engine(canvasEl);
        (canvasEl as any).__htmfx_engine = engine;
        HtmxUIDirective.registerEngine(engine);
        engine.start();
      }

      if (value) {
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
      }

      return engine;
    }

    if (isSpatialHost) {
      if (value) {
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
      }
    } else {
      // Applied on an entity element, parse xyz or rotation
      if (value) {
        const coords = UnitParser.parseVec3(value);
        el.setAttribute('xyz', `${coords[0]}, ${coords[1]}, ${coords[2]}`);
      }
    }

    return null;
  }
}
