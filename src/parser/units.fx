/**
 * htmFX Unit and Coordinate Parsers (.fx)
 * Parses declarative string representations into typed mathematical structures.
 */

export interface Vec3Tuple {
  x: number;
  y: number;
  z: number;
}

export class UnitParser {
  /**
   * Parse a 3D coordinate/vector string like "0, 10, -50" or "[0, 10, -50]" or "0 10 -50"
   */
  static parseVec3(value: string | number[] | Vec3Tuple | null | undefined, defaultValue: [number, number, number] = [0, 0, 0]): [number, number, number] {
    if (!value) return defaultValue;
    
    if (Array.isArray(value)) {
      return [
        Number(value[0]) || 0,
        Number(value[1]) || 0,
        Number(value[2]) || 0
      ];
    }

    if (typeof value === 'object' && 'x' in value && 'y' in value && 'z' in value) {
      return [Number(value.x) || 0, Number(value.y) || 0, Number(value.z) || 0];
    }

    if (typeof value === 'string') {
      const clean = value.replace(/[\[\]\(\)]/g, '').trim();
      const parts = clean.split(/[\s,]+/).filter(Boolean).map(v => parseFloat(v));
      if (parts.length >= 3) {
        return [parts[0] || 0, parts[1] || 0, parts[2] || 0];
      } else if (parts.length === 1 && !isNaN(parts[0])) {
        return [parts[0], parts[0], parts[0]];
      }
    }

    return defaultValue;
  }

  /**
   * Parse rotation in degrees or radians like "0, 90deg, 0" or "0, 1.57rad, 0"
   * Returns radians [rx, ry, rz]
   */
  static parseRotation(value: string | number[] | null | undefined, defaultValue: [number, number, number] = [0, 0, 0]): [number, number, number] {
    if (!value) return defaultValue;

    if (Array.isArray(value)) {
      return [
        Number(value[0]) || 0,
        Number(value[1]) || 0,
        Number(value[2]) || 0
      ];
    }

    if (typeof value === 'string') {
      const clean = value.replace(/[\[\]\(\)]/g, '').trim();
      const parts = clean.split(/[\s,]+/).filter(Boolean);
      
      const rads: [number, number, number] = [0, 0, 0];
      for (let i = 0; i < Math.min(3, parts.length); i++) {
        const str = parts[i];
        if (str.endsWith('deg')) {
          rads[i] = (parseFloat(str) * Math.PI) / 180;
        } else if (str.endsWith('rad')) {
          rads[i] = parseFloat(str);
        } else if (str.endsWith('turn')) {
          rads[i] = parseFloat(str) * Math.PI * 2;
        } else {
          const num = parseFloat(str);
          rads[i] = (num * Math.PI) / 180; // Default HTML declarations to degrees
        }
      }
      return rads;
    }

    return defaultValue;
  }

  /**
   * Parse speed/velocity strings with units (e.g. "15m/s", "100km/h", "Mach 2", "50knots")
   * Returns meters per second (m/s)
   */
  static parseSpeed(value: string | number | null | undefined, defaultSpeed: number = 0): number {
    if (value === null || value === undefined) return defaultSpeed;
    if (typeof value === 'number') return value;

    const str = String(value).trim().toLowerCase();
    
    if (str.startsWith('mach')) {
      const mach = parseFloat(str.replace('mach', '').trim()) || 1;
      return mach * 343; // ~343 m/s at sea level standard atmosphere
    }
    
    if (str.endsWith('km/h') || str.endsWith('kph')) {
      return (parseFloat(str) / 3.6);
    }
    
    if (str.endsWith('mph')) {
      return parseFloat(str) * 0.44704;
    }

    if (str.endsWith('knots') || str.endsWith('kt')) {
      return parseFloat(str) * 0.514444;
    }

    if (str.endsWith('m/s')) {
      return parseFloat(str);
    }

    const parsed = parseFloat(str);
    return isNaN(parsed) ? defaultSpeed : parsed;
  }

  /**
   * Parse distance / altitude strings with units (e.g. "500m", "10km", "2000ft")
   * Returns meters (m)
   */
  static parseDistance(value: string | number | null | undefined, defaultVal: number = 0): number {
    if (value === null || value === undefined) return defaultVal;
    if (typeof value === 'number') return value;

    const str = String(value).trim().toLowerCase();
    if (str.endsWith('km')) {
      return parseFloat(str) * 1000;
    }
    if (str.endsWith('m')) {
      return parseFloat(str);
    }
    if (str.endsWith('ft')) {
      return parseFloat(str) * 0.3048;
    }
    if (str.endsWith('mi') || str.endsWith('miles')) {
      return parseFloat(str) * 1609.34;
    }

    const parsed = parseFloat(str);
    return isNaN(parsed) ? defaultVal : parsed;
  }

  /**
   * Parse RGBA / Hex / Named Color to Float32Array [r, g, b, a] in 0.0 - 1.0 range
   */
  static parseColor(value: string | null | undefined, defaultColor: [number, number, number, number] = [1, 1, 1, 1]): [number, number, number, number] {
    if (!value) return defaultColor;

    const str = value.trim();

    // Hex #RRGGBB or #RRGGBBAA or #RGB
    if (str.startsWith('#')) {
      const hex = str.substring(1);
      if (hex.length === 3) {
        const r = parseInt(hex[0] + hex[0], 16) / 255;
        const g = parseInt(hex[1] + hex[1], 16) / 255;
        const b = parseInt(hex[2] + hex[2], 16) / 255;
        return [r, g, b, 1.0];
      } else if (hex.length === 6) {
        const r = parseInt(hex.substring(0, 2), 16) / 255;
        const g = parseInt(hex.substring(2, 4), 16) / 255;
        const b = parseInt(hex.substring(4, 6), 16) / 255;
        return [r, g, b, 1.0];
      } else if (hex.length === 8) {
        const r = parseInt(hex.substring(0, 2), 16) / 255;
        const g = parseInt(hex.substring(2, 4), 16) / 255;
        const b = parseInt(hex.substring(4, 6), 16) / 255;
        const a = parseInt(hex.substring(6, 8), 16) / 255;
        return [r, g, b, a];
      }
    }

    // rgb(r, g, b) or rgba(r, g, b, a)
    if (str.startsWith('rgb')) {
      const parts = str.replace(/rgba?\(|\)/gi, '').split(',').map(s => parseFloat(s.trim()));
      return [
        (parts[0] || 0) / 255,
        (parts[1] || 0) / 255,
        (parts[2] || 0) / 255,
        parts.length > 3 ? (parts[3] ?? 1.0) : 1.0
      ];
    }

    // Common Named Colors
    const namedColors: Record<string, [number, number, number, number]> = {
      white: [1, 1, 1, 1],
      black: [0, 0, 0, 1],
      red: [1, 0, 0, 1],
      green: [0, 1, 0, 1],
      blue: [0, 0, 1, 1],
      cyan: [0, 1, 1, 1],
      magenta: [1, 0, 1, 1],
      yellow: [1, 1, 0, 1],
      orange: [1, 0.647, 0, 1],
      purple: [0.5, 0, 0.5, 1],
      indigo: [0.29, 0, 0.51, 1],
      neon_blue: [0.0, 0.8, 1.0, 1],
      neon_pink: [1.0, 0.08, 0.58, 1],
      gold: [1.0, 0.843, 0.0, 1],
      transparent: [0, 0, 0, 0]
    };

    if (namedColors[str.toLowerCase()]) {
      return namedColors[str.toLowerCase()];
    }

    return defaultColor;
  }
}
