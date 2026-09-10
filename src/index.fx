/**
 * htmFX: Declarative 3D, WebGPU & Spatial Simulation Companion for htmxUI (.fx)
 * Version: 1.0.0
 * Architecture: Decoupled Spatial Companion Layer
 */

// Math & Core
export * from './core/math.fx';
export * from './core/camera.fx';
export * from './core/geometry.fx';
export * from './core/materials.fx';
export * from './core/gltf-loader.fx';
export * from './core/engine.fx';

// Physics Solvers & Dynamic Forces
export * from './physics/fog-field.fx';
export * from './physics/attenuation.fx';
export * from './physics/ballistics-rk4.fx';
export * from './physics/collision.fx';
export * from './physics/forces.fx';
export * from './physics/integrators.fx';
export * from './physics/rigid-body-3d.fx';
export * from './physics/constraints.fx';

// 200+ Spatial FX & Flow Fields
export * from './fx/flow-fields.fx';
export * from './fx/particle-catalogue.fx';

// Spatial Edge DB (InnoDB-style Flat Spatial Storage Engine)
export * from './db/spatial-edge-db.fx';

// Parsers & Grammars
export * from './parser/units.fx';
export * from './parser/macro-parser.fx';
export * from './parser/mx-grammar.fx';

// Presets
export * from './presets/environments.fx';
export * from './presets/atmospheres.fx';

// HTMX & htmxUI Bridges
export * from './htmx/htmx-bridge.fx';
export * from './htmxui/htmxui-directive.fx';

// Web Components
import { HxViewportElement } from './elements/hx-viewport.fx';
import { HxMeshElement } from './elements/hx-mesh.fx';
import { HxParticleElement } from './elements/hx-particle.fx';
import { HxEmitterElement } from './elements/hx-emitter.fx';
import { HxLightElement } from './elements/hx-light.fx';
import { HxTerrainElement } from './elements/hx-terrain.fx';
import { HxCameraElement } from './elements/hx-camera.fx';
import { HxAudioElement } from './elements/hx-audio.fx';
import { HxColliderElement } from './elements/hx-collider.fx';
import { HtmxBridge } from './htmx/htmx-bridge.fx';
import { HtmxUIDirective } from './htmxui/htmxui-directive.fx';

export {
  HxViewportElement,
  HxMeshElement,
  HxParticleElement,
  HxEmitterElement,
  HxLightElement,
  HxTerrainElement,
  HxCameraElement,
  HxAudioElement,
  HxColliderElement
};

// Automatic Custom Element Registration
if (typeof window !== 'undefined' && typeof customElements !== 'undefined') {
  if (!customElements.get('hx-viewport')) customElements.define('hx-viewport', HxViewportElement);
  if (!customElements.get('hx-mesh')) customElements.define('hx-mesh', HxMeshElement);
  if (!customElements.get('hx-particle')) customElements.define('hx-particle', HxParticleElement);
  if (!customElements.get('hx-emitter')) customElements.define('hx-emitter', HxEmitterElement);
  if (!customElements.get('hx-light')) customElements.define('hx-light', HxLightElement);
  if (!customElements.get('hx-terrain')) customElements.define('hx-terrain', HxTerrainElement);
  if (!customElements.get('hx-camera')) customElements.define('hx-camera', HxCameraElement);
  if (!customElements.get('hx-audio')) customElements.define('hx-audio', HxAudioElement);
  if (!customElements.get('hx-collider')) customElements.define('hx-collider', HxColliderElement);

  // Initialize bridges
  HtmxBridge.init();
  HtmxUIDirective.register();

  // Global namespace exposure
  const globalObj = window as any;
  globalObj.htmFX = globalObj.HtmFX = {
    version: '1.0.0',
    mount: HtmxUIDirective.mount,
    elements: {
      HxViewportElement,
      HxMeshElement,
      HxParticleElement,
      HxEmitterElement,
      HxLightElement,
      HxTerrainElement,
      HxCameraElement,
      HxAudioElement,
      HxColliderElement
    }
  };
}
