/**
 * htmFX Inverse-Square Distance Attenuation Solver (.fx)
 * Mathematical Formulation:
 *   I(d) = I₀ / (1 + k₁·d + k₂·d²)
 */

import { Vector3 } from '../core/math.fx';

export interface AttenuationConfig {
  initialIntensity: number; // I₀
  linearFactor: number;     // k₁
  quadraticFactor: number;  // k₂
  cutoffDistance: number;
  innerRadius: number;
}

export class AttenuationSolver {
  config: AttenuationConfig;

  constructor(config?: Partial<AttenuationConfig>) {
    this.config = {
      initialIntensity: config?.initialIntensity ?? 1.0,
      linearFactor: config?.linearFactor ?? 0.05,
      quadraticFactor: config?.quadraticFactor ?? 0.01,
      cutoffDistance: config?.cutoffDistance ?? 500.0,
      innerRadius: config?.innerRadius ?? 0.5
    };
  }

  evaluateAtDistance(d: number): number {
    if (d <= this.config.innerRadius) {
      return this.config.initialIntensity;
    }
    if (d >= this.config.cutoffDistance) {
      return 0.0;
    }

    const effectiveDist = d - this.config.innerRadius;
    const denominator = 1.0 + (this.config.linearFactor * effectiveDist) + (this.config.quadraticFactor * effectiveDist * effectiveDist);
    return this.config.initialIntensity / Math.max(0.0001, denominator);
  }

  evaluate(emitterPos: Vector3, receiverPos: Vector3): number {
    const dist = emitterPos.distanceTo(receiverPos);
    return this.evaluateAtDistance(dist);
  }

  computeHeatHazeDisplacement(emitterPos: Vector3, vertexPos: Vector3, timeSec: number, amplitude: number = 0.2): Vector3 {
    const intensity = this.evaluate(emitterPos, vertexPos);
    if (intensity <= 0.001) {
      return new Vector3(0, 0, 0);
    }

    const freq = 12.0;
    const waveX = Math.sin(vertexPos.y * freq + timeSec * 8.0) * Math.cos(vertexPos.z * 5.0);
    const waveY = Math.cos(vertexPos.x * freq + timeSec * 10.0) * 0.5;
    const waveZ = Math.sin(vertexPos.x * 5.0 + vertexPos.y * freq + timeSec * 6.0);

    const disp = new Vector3(waveX, waveY, waveZ);
    return disp.scale(intensity * amplitude);
  }

  computeSpatialAudio(emitterPos: Vector3, listenerPos: Vector3, listenerForward: Vector3, listenerRight: Vector3): { gain: number; pan: number } {
    const toEmitter = new Vector3().subVectors(emitterPos, listenerPos);
    const distance = toEmitter.length();
    const gain = this.evaluateAtDistance(distance);

    if (distance < 0.001) {
      return { gain, pan: 0 };
    }

    const normDir = toEmitter.clone().normalize();
    const pan = Math.max(-1, Math.min(1, normDir.dot(listenerRight)));

    return { gain, pan };
  }
}
