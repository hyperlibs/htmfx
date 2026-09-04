import { describe, it, expect } from 'vitest';
import { UnitParser } from '../src/parser/units.fx';
import { MacroParser } from '../src/parser/macro-parser.fx';
import { MxGrammarParser } from '../src/parser/mx-grammar.fx';

describe('UnitParser', () => {
  it('parses 3D vector coordinates correctly', () => {
    expect(UnitParser.parseVec3('0, 10, -50')).toEqual([0, 10, -50]);
    expect(UnitParser.parseVec3('[1.5, 2.5, 3.5]')).toEqual([1.5, 2.5, 3.5]);
    expect(UnitParser.parseVec3('5')).toEqual([5, 5, 5]);
  });

  it('parses rotation with degree and radian units', () => {
    const rotDeg = UnitParser.parseRotation('0, 90deg, 0');
    expect(rotDeg[1]).toBeCloseTo(Math.PI / 2, 5);

    const rotRad = UnitParser.parseRotation('0, 3.14159rad, 0');
    expect(rotRad[1]).toBeCloseTo(Math.PI, 4);
  });

  it('parses speed units (m/s, km/h, Mach)', () => {
    expect(UnitParser.parseSpeed('15m/s')).toBe(15);
    expect(UnitParser.parseSpeed('36km/h')).toBe(10);
    expect(UnitParser.parseSpeed('Mach 2')).toBeCloseTo(686, 1);
  });

  it('parses colors (Hex and RGB)', () => {
    const hex = UnitParser.parseColor('#ff0000');
    expect(hex).toEqual([1, 0, 0, 1]);

    const rgb = UnitParser.parseColor('rgb(255, 128, 0)');
    expect(rgb[0]).toBe(1);
    expect(rgb[1]).toBeCloseTo(128 / 255, 3);
    expect(rgb[2]).toBe(0);
  });
});

describe('MacroParser', () => {
  it('parses single macros with key-value pairs', () => {
    const parsed = MacroParser.parseSingle('$foggy(density: 0.06)');
    expect(parsed.name).toBe('foggy');
    expect(parsed.args.density).toBe(0.06);
  });

  it('parses composite directives with comma separations', () => {
    const parsed = MacroParser.parseDirectives('$foggy(density: 0.06), $windy(15m/s)');
    expect(parsed.presets).toContain('foggy');
    expect(parsed.presets).toContain('windy');
    expect(parsed.macros[0].args.density).toBe(0.06);
    expect(parsed.macros[1].args.value).toBe(15);
  });
});

describe('MxGrammarParser', () => {
  it('parses .mx documents with @model and spatial anchors', () => {
    const mxDoc = `
      # project: htmFX
      @model EnvConfig
        preset: EnvPreset
        fog_density: float
      @pin[top-left]
      @3d[0, 10, -50]
    `;
    const parsed = MxGrammarParser.parse(mxDoc);
    expect(parsed.meta.project).toBe('htmFX');
    expect(parsed.models['EnvConfig']).toBeDefined();
    expect(parsed.entities.length).toBe(2);
    expect(parsed.entities[0].anchor?.type).toBe('pin');
    expect(parsed.entities[1].anchor?.type).toBe('3d');
  });
});
