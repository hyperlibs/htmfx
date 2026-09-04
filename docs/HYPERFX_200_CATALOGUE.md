# 🌌 htmFX 200+ Spatial FX & Physics Library Catalogue

This document serves as the master catalog and technical reference for the 200+ built-in physics and particle effect presets provided by **htmFX** (`@hyperlibs/htmfx`).

---

## 📐 Unified Physics Formulation

Every effect in htmFX is computed via analytical physics kernels written in pure `.fx` (compiled to WebGPU compute shaders / WebGL2 instanced geometry):

### 1. Newtonian Gravity Wells (N-Body)
$$F_{\text{gravity}} = G \frac{m_1 m_2}{r^2 + \epsilon^2} \hat{\mathbf{r}}$$

### 2. Stokes Aerodynamic / Viscous Drag
$$F_{\text{stokes}} = -6 \pi \eta r \mathbf{v}$$

### 3. Archimedes Buoyant Floatation & Damping
$$F_{\text{buoyancy}} = \rho_{\text{fluid}} V_{\text{submerged}} g - c \mathbf{v}_{\text{rel}}$$

### 4. Lorentz Electromagnetic Deflection
$$F_{\text{lorentz}} = q (\mathbf{E} + \mathbf{v} \times \mathbf{B})$$

### 5. Damped Harmonic Spring-Damper (Hooke's Law)
$$F_{\text{spring}} = -k (\|\mathbf{x} - \mathbf{x}_0\| - L_0) \hat{\mathbf{x}} - c (\mathbf{v}_{\text{rel}} \cdot \hat{\mathbf{x}}) \hat{\mathbf{x}}$$

### 6. Divergence-Free 3D Curl Noise
$$\nabla \cdot (\nabla \times \mathbf{\Psi}) = 0 \implies \mathbf{v}_{\text{curl}} = \left( \frac{\partial \Psi_z}{\partial y} - \frac{\partial \Psi_y}{\partial z}, \frac{\partial \Psi_x}{\partial z} - \frac{\partial \Psi_z}{\partial x}, \frac{\partial \Psi_y}{\partial x} - \frac{\partial \Psi_x}{\partial y} \right)$$

---

## 🗂️ Taxonomy of 200+ Spatial FX

The catalogue is divided across 6 fundamental physical categories:

| Category | Count | Dominant Physics Dynamics | Representative Presets |
| :--- | :--- | :--- | :--- |
| **1. Thermal / Combustion / Plasma** | 40 | Buoyant thermal convection, ablation, thermobaric shocks | `$burn`, `$flare`, `$inferno`, `$plasma_torch`, `$napalm`, `$cinder`, `$solar_flare`, `$afterburner`, `$thermite`, `$magma_geyser` |
| **2. Electric / Ionization / Energy** | 40 | Coulomb/Lorentz fields, Lichtenberg dielectric breakdown, Tesla arcs | `$zap`, `$tesla_arc`, `$ball_lightning`, `$emp_burst`, `$ion_stream`, `$st_elmo_fire`, `$lightning_strike`, `$plasma_shield`, `$synchrotron_beam` |
| **3. Fluid / Liquid / Cryo** | 40 | Viscous droplet surface tension, splash crowns, cavitation, sublimation | `$splash`, `$splatter`, `$slime`, `$blizzard`, `$liquid_nitrogen`, `$acid_spray`, `$oil_slick`, `$geyser_spout`, `$whirlpool_funnel` |
| **4. Kinetic / Explosive / Shockwave** | 40 | Supersonic blast wave, fragmentation dispersion, elastomeric ricochet | `$explode`, `$implode`, `$sonic_boom`, `$railgun_slug`, `$shrapnel_burst`, `$orbital_strike`, `$c4_breach`, `$claymore_fan`, `$bullet_ricochet` |
| **5. Cosmic / Quantum / Distortion** | 40 | Gravitational singularity lensing, Alcubierre warp fields, Cherenkov beams | `$nebula`, `$wormhole_rift`, `$dark_matter_halo`, `$graviton_well`, `$event_horizon`, `$pulsar_beam`, `$warp_bubble`, `$quantum_foam` |
| **6. Atmospheric / Environmental / Bio** | 40 | Exponential altitude fog, haboob sand walls, bioluminescent plankton | `$foggy`, `$sandstorm`, `$aurora_borealis`, `$bioluminescence`, `$spore_cloud`, `$fireflies`, `$pollen_drift`, `$haboob_crest`, `$dust_devil` |

---

## 🚀 Declarative HTML & htmxUI Usage

### Mounting via Web Components
```html
<hx-viewport atmosphere="$foggy" camera="0, 5, 15">
  <!-- Flame Emitter with Stokes Drag & Convection -->
  <hx-emitter fx="$inferno" rate="2000" position="0, 0, 0"></hx-emitter>

  <!-- Electrical Arc Discharge -->
  <hx-particle fx="$tesla_arc" rate="800" position="5, 2, 0"></hx-particle>

  <!-- Cryogenic Mist Pool -->
  <hx-particle fx="$liquid_nitrogen" position="-5, 0, 0"></hx-particle>
</hx-viewport>
```

### Declarative htmxUI Spatial Directive
```html
<div hx-3d="3denv:$cyberpunk; 3datmos:$rainy; 3dcam:orbital; 3dfx:$plasma_shield"
     style="width: 100vw; height: 100vh;">
</div>
```

---

## 🔍 Programmatic API

```typescript
import {
  SPATIAL_FX_CATALOGUE,
  getSpatialFX,
  getSpatialFXByCategory,
  searchSpatialFXByTag,
  PhysicsForces,
  RigidBody3D,
  RigidBodyWorld,
  FlowFields
} from '@hyperlibs/htmfx';

// Retrieve preset metadata
const plasma = getSpatialFX('plasma_torch');
console.log(plasma.color, plasma.initialSpeed, plasma.rate);

// Query all electric effects
const electricFX = getSpatialFXByCategory('electric');

// Search by tag / keyword
const explosiveFX = searchSpatialFXByTag('shockwave');

// Evaluate dynamic Curl Noise for particles
const flow = FlowFields.computeCurlNoise(particlePos, time);
particleVel.add(flow);
```
