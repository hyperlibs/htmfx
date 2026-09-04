/**
 * htmFX <hx-audio> Web Component (.fx)
 * 3D Positional Spatial Audio entity with distance attenuation and panning.
 */

import { UnitParser } from '../parser/units.fx';
import { Vector3 } from '../core/math.fx';
import { AttenuationSolver } from '../physics/attenuation.fx';

export class HxAudioElement extends HTMLElement {
  private audioCtx: AudioContext | null = null;
  private panner: PannerNode | null = null;
  private gainNode: GainNode | null = null;
  private attenuation: AttenuationSolver = new AttenuationSolver();

  static get observedAttributes(): string[] {
    return ['src', 'xyz', 'spatial', 'volume', 'loop'];
  }

  connectedCallback(): void {
    const isSpatial = this.getAttribute('spatial') !== 'false';
    const volume = parseFloat(this.getAttribute('volume') || '1.0');
    // Web Audio setup when triggered by user gesture
  }

  playSpatialSound(emitterPos: Vector3, listenerPos: Vector3): void {
    const { gain, pan } = this.attenuation.computeSpatialAudio(
      emitterPos,
      listenerPos,
      new Vector3(0, 0, -1),
      new Vector3(1, 0, 0)
    );

    if (this.gainNode) {
      this.gainNode.gain.value = gain;
    }
  }
}
