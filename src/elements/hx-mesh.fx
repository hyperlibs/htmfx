/**
 * htmFX <hx-mesh> Web Component (.fx)
 */

import { UnitParser } from '../parser/units.fx';
import { GeometryBuilder, GeometryData } from '../core/geometry.fx';
import { Material } from '../core/materials.fx';
import { GLTFLoader } from '../core/gltf-loader.fx';
import { SceneNode } from '../core/engine.fx';
import { HxViewportElement } from './hx-viewport.fx';

export class HxMeshElement extends HTMLElement {
  node: SceneNode | null = null;
  private viewport: HxViewportElement | null = null;

  static get observedAttributes(): string[] {
    return ['src', 'xyz', 'rotation', 'scale', 'material', 'color', 'emissive', 'roughness', 'metalness', 'visible'];
  }

  connectedCallback(): void {
    this.viewport = this.closest('hx-viewport');
    if (!this.viewport) {
      setTimeout(() => this.attachToViewport(), 10);
    } else {
      this.attachToViewport();
    }
  }

  disconnectedCallback(): void {
    if (this.node && this.viewport?.engine) {
      const idx = this.viewport.engine.rootNode.children.indexOf(this.node);
      if (idx !== -1) {
        this.viewport.engine.rootNode.children.splice(idx, 1);
      }
    }
  }

  attributeChangedCallback(name: string, oldValue: string, newValue: string): void {
    if (oldValue === newValue || !this.node) return;
    this.syncSpatialState();
  }

  private async attachToViewport(): Promise<void> {
    this.viewport = this.closest('hx-viewport') || (document.querySelector('hx-viewport') as HxViewportElement);
    if (!this.viewport || !this.viewport.engine) {
      setTimeout(() => this.attachToViewport(), 50);
      return;
    }

    const engine = this.viewport.engine;
    this.node = engine.createNode(this.id || `mesh-${Math.random().toString(36).substr(2, 9)}`);
    this.node.userData = { element: this };

    await this.loadGeometry();
    this.syncSpatialState();

    engine.rootNode.children.push(this.node);
  }

  private async loadGeometry(): Promise<void> {
    const src = this.getAttribute('src');
    const shape = this.getAttribute('shape') || 'box';

    let geom: GeometryData;

    if (src) {
      geom = await GLTFLoader.load(src);
    } else if (shape === 'sphere') {
      geom = GeometryBuilder.createSphere(1, 24, 16);
    } else if (shape === 'cylinder') {
      geom = GeometryBuilder.createCylinder(1, 1, 2, 24);
    } else if (shape === 'plane') {
      geom = GeometryBuilder.createPlane(10, 10, 8, 8);
    } else {
      geom = GeometryBuilder.createBox(2, 2, 2);
    }

    if (this.node && this.viewport?.engine) {
      this.node.geometry = geom;
      this.viewport.engine.setupGeometryBuffers(this.node);
    }
  }

  syncSpatialState(): void {
    if (!this.node) return;

    const [x, y, z] = UnitParser.parseVec3(this.getAttribute('xyz'), [0, 0, 0]);
    this.node.position.set(x, y, z);

    const [rx, ry, rz] = UnitParser.parseRotation(this.getAttribute('rotation'), [0, 0, 0]);
    this.node.rotation.set(rx, ry, rz);

    const [sx, sy, sz] = UnitParser.parseVec3(this.getAttribute('scale'), [1, 1, 1]);
    this.node.scale.set(sx, sy, sz);

    const matType = (this.getAttribute('material') || 'standard') as any;
    const color = UnitParser.parseColor(this.getAttribute('color'), [0.8, 0.8, 0.8, 1.0]);
    const roughness = parseFloat(this.getAttribute('roughness') || '0.5');
    const metalness = parseFloat(this.getAttribute('metalness') || '0.1');

    this.node.material = new Material({
      color,
      roughness,
      metalness,
      shaderType: matType
    });

    const isVisible = this.getAttribute('visible') !== 'false';
    this.node.visible = isVisible;
  }
}
