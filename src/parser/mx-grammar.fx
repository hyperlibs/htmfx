/**
 * htmFX Flat Spatial Coordinate Grammar (.mx) Parser (.fx)
 * Parses @pin[anchor], @3d[x, y, z], @model, and tabular macro declarations.
 */

import { Vector3 } from '../core/math.fx';
import { UnitParser } from './units.fx';

export interface SpatialAnchor {
  type: 'pin' | '3d';
  anchor?: string;
  coords?: Vector3;
}

export interface MxDocument {
  meta: Record<string, string>;
  models: Record<string, Record<string, string>>;
  entities: Array<{
    id: string;
    anchor?: SpatialAnchor;
    attributes: Record<string, any>;
  }>;
}

export class MxGrammarParser {
  /**
   * Parses flat .mx grammar strings
   */
  static parse(content: string): MxDocument {
    const lines = content.split(/\r?\n/);
    const doc: MxDocument = {
      meta: {},
      models: {},
      entities: []
    };

    let currentModel: string | null = null;

    for (let line of lines) {
      line = line.trim();
      if (!line || line.startsWith('#')) {
        // Check meta headers like # project: htmFX
        const metaMatch = line.match(/^#\s*([a-zA-Z0-9_\-]+)\s*:\s*(.*)$/);
        if (metaMatch) {
          doc.meta[metaMatch[1]] = metaMatch[2].trim();
        }
        continue;
      }

      // @model Name
      const modelMatch = line.match(/^@model\s+([a-zA-Z0-9_\-]+)/);
      if (modelMatch) {
        currentModel = modelMatch[1];
        doc.models[currentModel] = {};
        continue;
      }

      // Inside @model field: type
      if (currentModel && line.includes(':')) {
        const [field, type] = line.split(':').map(s => s.trim());
        if (field && type) {
          doc.models[currentModel][field] = type;
        }
        continue;
      }

      // @pin[anchor] or @3d[x, y, z]
      const pinMatch = line.match(/@pin\[([a-zA-Z0-9_\-]+)\]/);
      if (pinMatch) {
        doc.entities.push({
          id: `pin-${doc.entities.length + 1}`,
          anchor: { type: 'pin', anchor: pinMatch[1] },
          attributes: {}
        });
        continue;
      }

      const d3Match = line.match(/@3d\[(.*)\]/);
      if (d3Match) {
        const coords = UnitParser.parseVec3(d3Match[1]);
        doc.entities.push({
          id: `entity-${doc.entities.length + 1}`,
          anchor: { type: '3d', coords: new Vector3(...coords) },
          attributes: {}
        });
        continue;
      }
    }

    return doc;
  }

  /**
   * Resolves a spatial anchor (@pin or @3d) to screen-space coordinates [leftPx, topPx]
   */
  static projectAnchorToScreen(anchor: SpatialAnchor, cameraMatrix: any, viewportWidth: number, viewportHeight: number): { x: number; y: number; visible: boolean } {
    if (anchor.type === 'pin') {
      switch (anchor.anchor) {
        case 'top-left': return { x: 20, y: 20, visible: true };
        case 'top-right': return { x: viewportWidth - 20, y: 20, visible: true };
        case 'bottom-left': return { x: 20, y: viewportHeight - 20, visible: true };
        case 'bottom-right': return { x: viewportWidth - 20, y: viewportHeight - 20, visible: true };
        case 'center': return { x: viewportWidth / 2, y: viewportHeight / 2, visible: true };
        default: return { x: 0, y: 0, visible: true };
      }
    }

    if (anchor.type === '3d' && anchor.coords) {
      // 3D projection
      return { x: viewportWidth / 2, y: viewportHeight / 2, visible: true };
    }

    return { x: 0, y: 0, visible: false };
  }
}
