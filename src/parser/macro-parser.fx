/**
 * htmFX Macro and Directive Grammar Parser (.fx)
 * Handles declarative expressions like $outdoor, $foggy(density: 0.06), $windy(15m/s)
 */

import { UnitParser } from './units.fx';

export interface ParsedMacro {
  name: string;
  args: Record<string, string | number | [number, number, number] | [number, number, number, number]>;
  rawArgs: string[];
}

export interface MacroDirectives {
  presets: string[];
  macros: ParsedMacro[];
}

export class MacroParser {
  /**
   * Parse a single macro string like "$foggy(density: 0.06)" or "$windy(15m/s)" or "$orbit"
   */
  static parseSingle(input: string): ParsedMacro {
    const trimmed = input.trim();
    if (!trimmed) {
      return { name: '', args: {}, rawArgs: [] };
    }

    const match = trimmed.match(/^\$?([a-zA-Z0-9_\-]+)(?:\((.*)\))?$/);
    if (!match) {
      return { name: trimmed.replace(/^\$/, ''), args: {}, rawArgs: [] };
    }

    const name = match[1].toLowerCase();
    const argsString = match[2];
    const args: Record<string, any> = {};
    const rawArgs: string[] = [];

    if (argsString) {
      const parts = argsString.split(',').map(s => s.trim()).filter(Boolean);

      parts.forEach(part => {
        rawArgs.push(part);
        if (part.includes(':')) {
          const [key, ...rest] = part.split(':');
          const val = rest.join(':').trim();
          args[key.trim()] = MacroParser.parseArgumentValue(val);
        } else if (part.includes('=')) {
          const [key, ...rest] = part.split('=');
          const val = rest.join('=').trim();
          args[key.trim()] = MacroParser.parseArgumentValue(val);
        } else {
          args['value'] = MacroParser.parseArgumentValue(part);
        }
      });
    }

    return { name, args, rawArgs };
  }

  /**
   * Parse a composite directive string like "$foggy(density: 0.06), $windy(15m/s)"
   */
  static parseDirectives(input: string | null | undefined): MacroDirectives {
    if (!input) {
      return { presets: [], macros: [] };
    }

    const macroStrings: string[] = [];
    let current = '';
    let depth = 0;

    for (let i = 0; i < input.length; i++) {
      const char = input[i];
      if (char === '(' || char === '[' || char === '{') {
        depth++;
        current += char;
      } else if (char === ')' || char === ']' || char === '}') {
        depth--;
        current += char;
      } else if (char === ',' && depth === 0) {
        if (current.trim()) macroStrings.push(current.trim());
        current = '';
      } else {
        current += char;
      }
    }
    if (current.trim()) macroStrings.push(current.trim());

    const presets: string[] = [];
    const macros: ParsedMacro[] = [];

    for (const str of macroStrings) {
      const parsed = MacroParser.parseSingle(str);
      if (parsed.name) {
        presets.push(parsed.name);
        macros.push(parsed);
      }
    }

    return { presets, macros };
  }

  private static parseArgumentValue(val: string): any {
    const clean = val.replace(/^["']|["']$/g, '').trim();

    // Speed
    if (/^\d+(\.\d+)?(m\/s|km\/h|kph|mph|knots|mach)/i.test(clean)) {
      return UnitParser.parseSpeed(clean);
    }

    // Altitude / Distance
    if (/^\d+(\.\d+)?(m|km|ft|mi|miles)/i.test(clean)) {
      return UnitParser.parseDistance(clean);
    }

    // Color
    if (clean.startsWith('#') || clean.startsWith('rgb')) {
      return UnitParser.parseColor(clean);
    }

    // Numbers
    const num = Number(clean);
    if (!isNaN(num) && clean !== '') {
      return num;
    }

    // Boolean
    if (clean === 'true') return true;
    if (clean === 'false') return false;

    return clean;
  }
}
