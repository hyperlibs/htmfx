/**
 * htmFX Environment Presets (.fx)
 */

import { Vector3 } from '../core/math.fx';
import { CameraMode } from '../core/camera.fx';

export interface EnvironmentPreset {
  name: string;
  defaultCamera: CameraMode;
  sunDirection: Vector3;
  sunColor: [number, number, number];
  ambientLight: [number, number, number];
  clearColor: [number, number, number, number];
  fogDensity: number;
  fogScaleHeight: number;
  fogColor: [number, number, number];
  altitudeM: number;
}

export const ENV_PRESETS: Record<string, EnvironmentPreset> = {
  space: {
    name: 'space',
    defaultCamera: 'orbit',
    sunDirection: new Vector3(1, -0.5, 1).normalize(),
    sunColor: [1.2, 1.2, 1.2],
    ambientLight: [0.02, 0.02, 0.05],
    clearColor: [0.01, 0.01, 0.02, 1.0],
    fogDensity: 0.0,
    fogScaleHeight: 1000000.0,
    fogColor: [0.01, 0.01, 0.02],
    altitudeM: 1000000.0
  },

  outdoor: {
    name: 'outdoor',
    defaultCamera: 'first_person',
    sunDirection: new Vector3(1, -2, 0.8).normalize(),
    sunColor: [1.0, 0.96, 0.88],
    ambientLight: [0.25, 0.28, 0.35],
    clearColor: [0.45, 0.65, 0.9, 1.0],
    fogDensity: 0.08,
    fogScaleHeight: 350.0,
    fogColor: [0.65, 0.75, 0.88],
    altitudeM: 500.0
  },

  cyberpunk: {
    name: 'cyberpunk',
    defaultCamera: 'cinematic',
    sunDirection: new Vector3(-1, -1.5, -0.5).normalize(),
    sunColor: [0.9, 0.1, 0.7],
    ambientLight: [0.08, 0.15, 0.3],
    clearColor: [0.02, 0.03, 0.08, 1.0],
    fogDensity: 0.04,
    fogScaleHeight: 250.0,
    fogColor: [0.08, 0.05, 0.18],
    altitudeM: 50.0
  },

  underwater: {
    name: 'underwater',
    defaultCamera: 'fly',
    sunDirection: new Vector3(0, -1, 0).normalize(),
    sunColor: [0.2, 0.8, 0.9],
    ambientLight: [0.05, 0.2, 0.3],
    clearColor: [0.01, 0.12, 0.22, 1.0],
    fogDensity: 0.25,
    fogScaleHeight: 100.0,
    fogColor: [0.02, 0.15, 0.28],
    altitudeM: -50.0
  },

  dungeon: {
    name: 'dungeon',
    defaultCamera: 'first_person',
    sunDirection: new Vector3(0.5, -1, 0.2).normalize(),
    sunColor: [0.8, 0.5, 0.2],
    ambientLight: [0.04, 0.03, 0.03],
    clearColor: [0.03, 0.02, 0.02, 1.0],
    fogDensity: 0.02,
    fogScaleHeight: 50.0,
    fogColor: [0.06, 0.04, 0.03],
    altitudeM: -200.0
  },

  desert: {
    name: 'desert',
    defaultCamera: 'orbit',
    sunDirection: new Vector3(0.3, -2, 0.5).normalize(),
    sunColor: [1.2, 1.05, 0.8],
    ambientLight: [0.35, 0.3, 0.2],
    clearColor: [0.85, 0.75, 0.55, 1.0],
    fogDensity: 0.15,
    fogScaleHeight: 400.0,
    fogColor: [0.82, 0.68, 0.45],
    altitudeM: 1200.0
  },

  arctic: {
    name: 'arctic',
    defaultCamera: 'orbit',
    sunDirection: new Vector3(1, -0.8, 0.5).normalize(),
    sunColor: [0.95, 0.98, 1.1],
    ambientLight: [0.35, 0.4, 0.5],
    clearColor: [0.75, 0.85, 0.95, 1.0],
    fogDensity: 0.1,
    fogScaleHeight: 500.0,
    fogColor: [0.8, 0.88, 0.96],
    altitudeM: 150.0
  },

  laboratory: {
    name: 'laboratory',
    defaultCamera: 'orbit',
    sunDirection: new Vector3(0, -1, 0).normalize(),
    sunColor: [1.0, 1.0, 1.0],
    ambientLight: [0.4, 0.45, 0.5],
    clearColor: [0.1, 0.12, 0.15, 1.0],
    fogDensity: 0.005,
    fogScaleHeight: 100.0,
    fogColor: [0.15, 0.18, 0.22],
    altitudeM: 10.0
  }
};
