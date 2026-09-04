/**
 * htmFX <hx-terrain> Web Component (.fx)
 * Generates volumetric mountain ridges, valleys, and biomes.
 */

import { GeometryBuilder } from '../core/geometry.fx';
import { Material } from '../core/materials.fx';
import { UnitParser } from '../parser/units.fx';
import { SceneNode } from '../core/engine.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxTerrainElement extends HTMLElement {
  node: SceneNode | null = null;
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['scale', 'maxHeight', 'biome', 'color', 'wireframe'];
  }

  connectedCallback(): void {
    this.attach();
  }

  private attach(): void {
    this.viewport = this.closest('hx-viewport') || (document.querySelector('hx-viewport') as HxViewportElement);
    if (!this.viewport || !this.viewport.engine) {
      setTimeout(() => this.attach(), 50);
      return;
    }

    const scale = parseFloat(this.getAttribute('scale') || '500');
    const maxHeight = parseFloat(this.getAttribute('maxHeight') || '45');
    const color = UnitParser.parseColor(this.getAttribute('color'), [0.2, 0.28, 0.35, 1.0]);
    const wireframe = this.getAttribute('wireframe') === 'true';

    const terrainGeom = GeometryBuilder.createTerrain(scale, scale, 64, maxHeight);

    const engine = this.viewport.engine;
    this.node = engine.createNode(this.id || 'terrain-node');
    this.node.geometry = terrainGeom;
    this.node.material = new Material({
      color,
      roughness: 0.85,
      metalness: 0.05,
      wireframe
    });

    engine.setupGeometryBuffers(this.node);
    engine.rootNode.children.push(this.node);
  }
}
