/**
 * htmFX Atmosphere Presets (.fx)
 */

export interface AtmospherePreset {
  name: string;
  fogDensity: number;
  fogScaleHeight: number;
  windSpeedMs: number;
  windDirection: [number, number, number];
  particleType?: string;
  particleCount?: number;
  particleColor?: [number, number, number, number];
}

export const ATMOS_PRESETS: Record<string, AtmospherePreset> = {
  clear: {
    name: 'clear',
    fogDensity: 0.01,
    fogScaleHeight: 600.0,
    windSpeedMs: 2.0,
    windDirection: [1, 0, 0]
  },

  cloudy: {
    name: 'cloudy',
    fogDensity: 0.04,
    fogScaleHeight: 450.0,
    windSpeedMs: 6.0,
    windDirection: [1, 0, 0.5]
  },

  rainy: {
    name: 'rainy',
    fogDensity: 0.06,
    fogScaleHeight: 300.0,
    windSpeedMs: 8.0,
    windDirection: [0.2, -1, 0.2],
    particleType: 'splash',
    particleCount: 1500,
    particleColor: [0.6, 0.75, 0.9, 0.6]
  },

  stormy: {
    name: 'stormy',
    fogDensity: 0.12,
    fogScaleHeight: 250.0,
    windSpeedMs: 20.0,
    windDirection: [1, -0.5, 0.5],
    particleType: 'splatter',
    particleCount: 2500,
    particleColor: [0.5, 0.6, 0.75, 0.7]
  },

  foggy: {
    name: 'foggy',
    fogDensity: 0.08,
    fogScaleHeight: 180.0,
    windSpeedMs: 1.5,
    windDirection: [0.5, 0, 0.2],
    particleType: 'radiate',
    particleCount: 800,
    particleColor: [0.85, 0.9, 0.95, 0.2]
  },

  windy: {
    name: 'windy',
    fogDensity: 0.02,
    fogScaleHeight: 500.0,
    windSpeedMs: 15.0,
    windDirection: [1, 0.1, 0]
  },

  snowy: {
    name: 'snowy',
    fogDensity: 0.07,
    fogScaleHeight: 350.0,
    windSpeedMs: 4.5,
    windDirection: [0.2, -0.8, 0.2],
    particleType: 'radiate',
    particleCount: 2000,
    particleColor: [0.95, 0.98, 1.0, 0.8]
  },

  sandstorm: {
    name: 'sandstorm',
    fogDensity: 0.15,
    fogScaleHeight: 200.0,
    windSpeedMs: 25.0,
    windDirection: [1, 0.1, 0.4],
    particleType: 'wave',
    particleCount: 3000,
    particleColor: [0.8, 0.65, 0.4, 0.7]
  },

  nebula: {
    name: 'nebula',
    fogDensity: 0.0,
    fogScaleHeight: 1000000.0,
    windSpeedMs: 0.0,
    windDirection: [0, 0, 0],
    particleType: 'nebula',
    particleCount: 4000,
    particleColor: [0.4, 0.3, 0.95, 0.85]
  }
};
