/**
 * htmFX <hx-viewport> Web Component (.fx)
 */

import { Engine } from '../core/engine.fx';
import { MacroParser } from '../parser/macro-parser.fx';
import { ENV_PRESETS } from '../presets/environments.fx';
import { ATMOS_PRESETS } from '../presets/atmospheres.fx';
import { CameraMode } from '../core/camera.fx';
import { Vector3 } from '../core/math.fx';
import { HtmxBridge } from '../htmx/htmx-bridge.fx';

export class HxViewportElement extends HTMLElement {
  engine: Engine | null = null;
  private canvas: HTMLCanvasElement | null = null;
  private resizeObserver: ResizeObserver | null = null;

  static get observedAttributes(): string[] {
    return ['3denv', '3datmos', '3dcamera', 'width', 'height'];
  }

  connectedCallback(): void {
    if (!this.shadowRoot) {
      const shadow = this.attachShadow({ mode: 'open' });
      const style = document.createElement('style');
      style.textContent = `
        :host {
          display: block;
          position: relative;
          width: 100%;
          height: 100%;
          min-height: 300px;
          overflow: hidden;
          background: #000;
        }
        canvas {
          display: block;
          width: 100%;
          height: 100%;
          touch-action: none;
        }
        .hud-layer {
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          pointer-events: none;
        }
        ::slotted(*) {
          pointer-events: auto;
        }
      `;
      shadow.appendChild(style);

      this.canvas = document.createElement('canvas');
      shadow.appendChild(this.canvas);

      const slot = document.createElement('slot');
      const hud = document.createElement('div');
      hud.className = 'hud-layer';
      hud.appendChild(slot);
      shadow.appendChild(hud);
    }

    if (this.canvas && !this.engine) {
      try {
        this.engine = new Engine(this.canvas);
        this.applyDirectives();
        this.engine.start();

        if (typeof ResizeObserver !== 'undefined') {
          this.resizeObserver = new ResizeObserver(() => {
            this.engine?.resize();
          });
          this.resizeObserver.observe(this);
        }
      } catch (e) {
        console.error('[htmFX] Failed to initialize WebGL viewport:', e);
      }
    }

    HtmxBridge.init();
  }

  disconnectedCallback(): void {
    if (this.engine) {
      this.engine.stop();
      this.engine = null;
    }
    if (this.resizeObserver) {
      this.resizeObserver.disconnect();
    }
  }

  attributeChangedCallback(name: string, oldValue: string, newValue: string): void {
    if (oldValue === newValue || !this.engine) return;
    this.applyDirectives();
  }

  applyDirectives(): void {
    if (!this.engine) return;

    const envAttr = this.getAttribute('3denv') || '$outdoor';
    const envMacro = MacroParser.parseSingle(envAttr);
    const preset = ENV_PRESETS[envMacro.name] || ENV_PRESETS['outdoor'];

    this.engine.clearColor = [...preset.clearColor];
    this.engine.sunDirection = preset.sunDirection.clone();
    this.engine.sunColor = [...preset.sunColor];
    this.engine.ambientLight = [...preset.ambientLight];

    this.engine.fogField.config.baseDensity = preset.fogDensity;
    this.engine.fogField.config.scaleHeight = preset.fogScaleHeight;
    this.engine.fogField.config.color = [...preset.fogColor];
    this.engine.fogField.config.referenceAltitude = preset.altitudeM;

    const atmosAttr = this.getAttribute('3datmos');
    if (atmosAttr) {
      const parsedAtmos = MacroParser.parseDirectives(atmosAttr);
      for (const m of parsedAtmos.macros) {
        const atmosPreset = ATMOS_PRESETS[m.name];
        if (atmosPreset) {
          if (m.args.density !== undefined) {
            this.engine.fogField.config.baseDensity = Number(m.args.density);
          } else {
            this.engine.fogField.config.baseDensity = atmosPreset.fogDensity;
          }

          if (atmosPreset.particleType && !this.querySelector('hx-particle')) {
            this.engine.addParticleEmitter(
              atmosPreset.particleType,
              atmosPreset.particleCount ?? 1000,
              atmosPreset.particleColor ?? [1, 1, 1, 0.5],
              new Vector3(0, 5, 0)
            );
          }
        }
      }
    }

    const camAttr = this.getAttribute('3dcamera');
    if (camAttr) {
      const camMacro = MacroParser.parseSingle(camAttr);
      const mode = (camMacro.name || preset.defaultCamera) as CameraMode;
      this.engine.camera.setMode(mode);
    } else {
      this.engine.camera.setMode(preset.defaultCamera);
    }
  }

  refreshScene(): void {
    this.applyDirectives();
  }
}
