# 🧠 The Ultimate Wiki for Agentic AI Builders, Vibe Architects & Smart Developers: HyperFX on htmxUI

> **"Eliminate 400 lines of Three.js boilerplate. Replace div soup with flat spatial coordinates. Build AAA WebGPU games, supersonic physics simulators, and reactive hypermedia worlds with 3 lines of HTML."**

---

## 📑 Table of Contents
1. [Executive Vision: The 3-Tier Spatial Hypermedia Stack](#1-executive-vision-the-3-tier-spatial-hypermedia-stack)
2. [Comprehensive Comparison: HyperFX vs Three.js, Babylon.js & React Three Fiber (R3F)](#2-comprehensive-comparison-hyperfx-vs-threejs-babylonjs--react-three-fiber-r3f)
3. [Agentic Token Economy & Context Slashing (Why LLMs Excel at HyperFX)](#3-agentic-token-economy--context-slashing-why-llms-excel-at-hyperfx)
4. [The Flat Spatial Grammar (`.mx`) & Functional Logic (`.fx`)](#4-the-flat-spatial-grammar-mx--functional-logic-fx)
5. [Embedded Mathematical Solvers & Physics Kernels](#5-embedded-mathematical-solvers--physics-kernels)
6. [Building Real-World WebGPU Games & Simulators: Complete Blueprints](#6-building-real-world-webgpu-games--simulators-complete-blueprints)
   - *Blueprint A: Supersonic Ballistics & Missile Defense Simulator (RK4)*
   - *Blueprint B: Cyberpunk Drone Flight & Volumetric Exponential Fog*
   - *Blueprint C: Server-Driven Hypermedia Battlefield HUD with `htmxUI` Signals*
7. [Deterministic AI Self-Healing & Diagnostics API](#7-deterministic-ai-self-healing--diagnostics-api)
8. [Vibe Architect Quickstart Cheat Sheet](#8-vibe-architect-quickstart-cheat-sheet)

---

## 1. Executive Vision: The 3-Tier Spatial Hypermedia Stack

Modern 3D web development is plagued by two extremes:
1. **Imperative Monoliths**: 500-line WebGL setup files, manual render loop plumbing, and massive 600KB+ runtime bundles.
2. **SPA / VDOM Bloat**: React Three Fiber (R3F) setups that introduce heavy JSX reconcilers, fiber hooks, and state synchronization jank.

`htmxUI` + `HyperFX` (`htmFX`) + `HMLR` introduces a clean, decoupled 3-tier architecture:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          1. REACTIVE HYPERMEDIA LAYER                       │
│           htmxUI (github.com/hyperlibs/htmxUI) — 40KB Gzipped               │
│  • HxBolt Signals & Reactive State Management                               │
│  • 120 FPS High-Frequency Game Loop Ticker (HxBolt.ticker)                  │
│  • Server-Driven State Morphing (hx-swap, hx-get, hx-trigger)               │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ HTMXUI.directive('3d', ...)
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       2. DECLARATIVE SPATIAL COMPANION                      │
│            HyperFX / htmFX (github.com/hyperlibs/htmfx) — 17.6KB            │
│  • Declarative Web Components (<hx-viewport>, <hx-mesh>, <hx-particle>)     │
│  • Macro Grammars ($cyberpunk, $foggy(0.04), $orbit, $burn, $explode)      │
│  • Flat Spatial Coordinate Placement (@pin[top-left], @3d[x,y,z])           │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ High-Performance Physics Kernels
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         3. COMPUTE & PHYSICS RUNTIME                        │
│               Pure WebGL2 / WebGPU Engine Core & .fx Solvers                │
│  • Volumetric Exponential Height Fog Field: ρ(y) = ρ₀ · e^(-(y - y₀)/H)     │
│  • Inverse-Square Physical Attenuation: I(d) = I₀ / (1 + k₁d + k₂d²)        │
│  • Supersonic Drag RK4 Integrator: F_drag = -0.5·ρ(y)·Cd(Mach)·A·||v||·v    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Comprehensive Comparison: HyperFX vs Three.js, Babylon.js & React Three Fiber (R3F)

| Feature / Metric | **HyperFX (htmFX)** | **Three.js** | **Babylon.js** | **React Three Fiber (R3F)** |
| :--- | :--- | :--- | :--- | :--- |
| **Gzipped Core Size** | **~17.6 KB** 🚀 | ~160 KB – 650 KB (with loaders) | ~900 KB – 3.5 MB | ~380 KB (React + Three + R3F) |
| **Boilerplate Lines to 3D Scene** | **3 Lines of HTML** | 80 – 450 lines of JS | 60 – 250 lines of JS | 35 – 80 lines of JSX + Hooks |
| **Declarative HTML Integration** | **Native Web Components** (`<hx-viewport>`) | ❌ None (Pure JS Imperative) | ❌ None (Pure JS Imperative) | ⚠️ React JSX Only |
| **Server-Driven Hypermedia / HTMX** | **100% Native** (`hx-swap="outerHTML"`) | ❌ Requires custom bridging | ❌ Requires custom bridging | ❌ Incompatible (SPA Only) |
| **Built-in Volumetric Height Fog** | **Native Analytical Closed-Form** | ⚠️ Custom Shader Chunk Patching | ⚠️ Custom Volumetric Pass | ⚠️ Custom GLSL Shader Pass |
| **Supersonic Ballistics (RK4)** | **Built-in Altitude & Mach Solver** | ❌ None (Needs external Ammo/Rapier) | ❌ None (Needs external Havok) | ❌ None (Needs external Rapier) |
| **Inverse-Square Physical Emitters** | **Built-in (`$burn`, `$zap`, `$explode`)** | ❌ Manual Particle Buffers | ⚠️ Heavy Particle System Module | ⚠️ Manual Shader Instances |
| **LLM Token Context Consumption** | **~80 Tokens** | ~800 – 2,200 Tokens | ~1,200 – 3,000 Tokens | ~700 – 1,500 Tokens |
| **Frame Ticker** | **`HxBolt.ticker` (120 FPS Subscribed)** | `requestAnimationFrame` loop | `scene.registerBeforeRender` | React Hook Reconciliation Loop |
| **Memory Footprint & GC Pressure** | **Ultra-Low (Typed Array Pool)** | Medium | High | High (React Fiber Node Garbage) |

---

## 3. Agentic Token Economy & Context Slashing (Why LLMs Excel at HyperFX)

When autonomous AI agents (such as DeepMind Antigravity, Claude, or GPT-4o) build 3D scenes, traditional Three.js code burns **800 to 2,500 tokens per prompt**, leading to:
- Frequent context window exhaustion
- High hallucination rates in vector math boilerplate
- Complex state-management bugs

### 🔴 The Three.js Token Drain (1,200+ Tokens)
```javascript
// 50 lines of boilerplate just to set up lights, camera, scene, renderer, animation loop, resize listener...
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);
const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);
const ambient = new THREE.AmbientLight(0x404040, 2);
scene.add(ambient);
const dirLight = new THREE.DirectionalLight(0xffffff, 1.5);
dirLight.position.set(1, 2, 1);
scene.add(dirLight);
const loader = new GLTFLoader();
loader.load('/models/drone.gltf', (gltf) => {
  gltf.scene.position.set(0, 10, -50);
  scene.add(gltf.scene);
});
// Fog setup, Particle setup, Resize event listener, RAF loop...
```

### 🟢 The HyperFX Agentic Standard (80 Tokens)
```html
<hx-viewport 3denv="$cyberpunk" 3datmos="$foggy(0.04)" 3dcamera="$orbit">
  <hx-mesh src="drone" xyz="0, 10, -50" material="hologram" color="#06b6d4"></hx-mesh>
  <hx-particle type="nebula" count="3500" color="#6366f1"></hx-particle>
  <hx-light type="sun" direction="[1, -2, 1]" intensity="1.5"></hx-light>
</hx-viewport>
```

> **Agentic Slashing**: 93% token reduction with zero hallucination surface.

---

## 4. The Flat Spatial Grammar (`.mx`) & Functional Logic (`.fx`)

### 4.1 Flat Spatial Grammar (`.mx`)
HyperFX replaces deeply nested "div soup" with flat spatial document declarations:

```text
# @meta
# project: CyberDefense
# runtime: hmlr@1.0

@model DefenseGrid
  radar_range_km: float
  interceptor_count: int
  threat_level: string

@pin[top-left]     -> HUD Radar & Tactical Threat Gauge
@pin[top-right]    -> Kill Count & Missile Telemetry
@3d[0, 20, -100]   -> Interceptor Battery Node
@3d[50, 120, -400] -> Inbound Hypersonic Target
```

### 4.2 Functional Logic (`.fx`)
All mathematical solvers, coordinate transformations, and data models are authored as pure functional `.fx` modules with zero side-effects.

---

## 5. Embedded Mathematical Solvers & Physics Kernels

### 5.1 Volumetric Exponential Height Fog Field
$$\rho(y) = \rho_0 \cdot e^{-\frac{y - y_0}{H}}$$

- **Valley Sea-of-Clouds**: Below $y_0 = 500\text{m}$, air density $\rho \approx 0.85$, enveloping ground structures in realistic atmospheric scattering.
- **Mountain Clearing**: Above $2000\text{m}$, $\rho \approx 0.02$, yielding clear skies with volumetric depth cues.
- **Analytical Closed-Form Ray Transmittance**:
  $$\tau(p_1, p_2) = \frac{\rho_0 \cdot H}{|y_2 - y_1|} \left|e^{-\frac{y_1 - y_0}{H}} - e^{-\frac{y_2 - y_0}{H}}\right| \cdot \|p_2 - p_1\|$$
  $$T(p_1, p_2) = e^{-\tau(p_1, p_2)}$$

### 5.2 Inverse-Square Distance Attenuation
$$I(d) = \frac{I_0}{1 + k_1 \cdot d + k_2 \cdot d^2}$$

- Integrated directly for:
  1. Particle emission falloffs (`$burn`, `$explode`, `$zap`, `$slime`, `$wave`)
  2. 3D Spatial Audio gain and binaural pan calculations
  3. Vertex heat-haze distortion fields

### 5.3 Supersonic Ballistics & Altitude Drag Solver (RK4)
$$\vec{F}_{\text{drag}} = -\frac{1}{2} \cdot \rho(y) \cdot C_d(\text{Mach}) \cdot A \cdot \|\vec{v}_{\text{rel}}\| \cdot \vec{v}_{\text{rel}}$$
$$\vec{a}(t, \vec{r}, \vec{v}) = \vec{g} + \frac{\vec{F}_{\text{drag}}}{m}$$

- **Transonic Wave Drag Rise**: Accurately simulates the sound barrier drag surge at Mach 0.75 – 1.2 and asymptotic decay at Mach 2.5+.
- **Crosswind Shear**: Evaluates logarithmic altitude wind shear $\vec{v}_{\text{wind}}(y)$.
- **Material Ricochet Matrix**:
  $$v_{\text{normal}}' = -e_{\text{restitution}} \cdot v_{\text{normal}}$$
  $$v_{\text{tangent}}' = (1 - \mu_{\text{friction}}) \cdot v_{\text{tangent}}$$

---

## 6. Building Real-World WebGPU Games & Simulators: Complete Blueprints

### 🎮 Blueprint A: Supersonic Ballistics & Missile Defense Simulator
```html
<script src="/dist/htmfx.js"></script>

<hx-viewport 3denv="$desert" 3datmos="$sandstorm, $windy(25m/s)" 3dcamera="$cinematic">
  <!-- Ground Terrain -->
  <hx-terrain scale="1000" maxHeight="50" color="#78350f"></hx-terrain>
  
  <!-- Defense Turret -->
  <hx-mesh id="battery" src="drone" xyz="0, 5, 0" material="standard" color="#3b82f6"></hx-mesh>
  
  <!-- Inbound Missile -->
  <hx-mesh id="inbound-missile" src="rocket" xyz="200, 300, -800" rotation="180deg, 0, 0" material="standard" color="#ef4444"></hx-mesh>
  
  <!-- Atmospheric Sandstorm Particles -->
  <hx-emitter type="$wave" rate="3000" color="#d97706"></hx-emitter>
  
  <!-- Sunlight -->
  <hx-light type="sun" direction="[0.5, -1, 0.5]" intensity="1.8" color="#fef3c7"></hx-light>
</hx-viewport>

<script>
  // High-Precision RK4 Trajectory Update
  const missile = document.getElementById('inbound-missile');
  const solver = new htmFX.BallisticsRK4Solver({ massKg: 120, referenceCd: 0.22 });
  
  let state = { position: new htmFX.Vector3(200, 300, -800), velocity: new htmFX.Vector3(-150, -40, 350), time: 0 };
  
  HxBolt.ticker.subscribe((timestamp, dt) => {
    state = solver.stepRK4(state, dt * 0.001);
    missile.setAttribute('xyz', `${state.position.x.toFixed(1)}, ${state.position.y.toFixed(1)}, ${state.position.z.toFixed(1)}`);
  });
</script>
```

---

### 🛸 Blueprint B: Cyberpunk Drone Flight with Hologram Materials & Volumetric Fog
```html
<hx-viewport 3denv="$cyberpunk" 3datmos="$foggy(0.06), $rainy" 3dcamera="$first_person">
  <!-- City Megastructures -->
  <hx-mesh src="box" scale="20, 180, 20" xyz="-50, 90, -100" material="hologram" color="#06b6d4"></hx-mesh>
  <hx-mesh src="box" scale="30, 240, 30" xyz="60, 120, -150" material="hologram" color="#ec4899"></hx-mesh>
  
  <!-- Player Flight Drone -->
  <hx-mesh id="player-drone" src="drone" xyz="0, 25, 0" material="hologram" color="#a855f7"></hx-mesh>
  
  <!-- Neon Rain Emitter -->
  <hx-emitter type="$splash" rate="2000" color="#38bdf8"></hx-emitter>
  <hx-light type="sun" direction="[-1, -1.5, -0.5]" intensity="1.2" color="#f43f5e"></hx-light>
</hx-viewport>
```

---

### 📡 Blueprint C: Server-Driven Hypermedia Battlefield HUD with `htmxUI` Signals

Seamlessly update 3D entities from your backend API without writing frontend state management:

```html
<!-- Live Server-Driven Spawn Zone -->
<div id="battlefield-zone" 
     hx-get="/api/battlefield/entities" 
     hx-trigger="every 1s" 
     hx-swap="innerHTML">
  
  <!-- Server returns live declarative spatial entities -->
  <hx-mesh id="tank-101" src="drone" xyz="45, 0, -120" rotation="0, 45deg, 0" material="standard" color="#22c55e"></hx-mesh>
  <hx-mesh id="drone-204" src="drone" xyz="-80, 40, -90" material="hologram" color="#eab308"></hx-mesh>
  
  <!-- Trigger zone emitting spatial events -->
  <hx-collider xyz="0, 0, -100" size="20, 10, 20" 
               hx-trigger="spatial:collision" 
               hx-post="/api/battlefield/strike" 
               hx-target="#strike-log"></hx-collider>
</div>

<div id="strike-log"></div>
```

---

## 7. Deterministic AI Self-Healing & Diagnostics API (`.mx`)

In alignment with the Universal `.mx` policy, HyperFX rejects bloated JSON error blobs in favor of native `.mx` machine-parseable diagnostics (`@diag`, `@model BuildDiagnostic`), empowering Agentic AIs to parse, diagnose, and self-heal in a single pass:

```text
@model BuildDiagnostic
  code: string
  type: string
  description: string
  culprit: string
  fix_suggestion: string
  timestamp: string

@diag FX-0021
  type: DIRECTIVE_ERROR
  description: Unrecognized atmosphere macro parameter 'windy(1500m/s)' exceeds supersonic threshold without Mach prefix.
  culprit: <hx-viewport 3datmos="$windy(1500m/s)">
  fix_suggestion: Specify speed in Mach format: 3datmos="$windy(Mach 4.3)" or standard wind velocity: 3datmos="$windy(25m/s)".
  timestamp: 2026-09-04T12:30:00.000Z
```

---

## 8. Vibe Architect Quickstart Cheat Sheet

### Essential Macros & Presets

```html
<!-- Environment Presets -->
3denv="$space"       -> High-altitude vacuum, deep space sky, zero fog
3denv="$outdoor"     -> Natural sun, blue skies, mild valley height fog
3denv="$cyberpunk"   -> Dark neon atmosphere, cyan/magenta lighting
3denv="$desert"      -> High solar glare, low moisture, ambient sand tint
3denv="$dungeon"     -> Dim torchlight, tight near-field attenuation
3denv="$underwater"  -> Dense aqueous light absorption, blue/teal tint

<!-- Atmosphere Macros -->
3datmos="$foggy(density: 0.08)"  -> Volumetric exponential fog field
3datmos="$windy(15m/s)"          -> 3D aerodynamic crosswind shear
3datmos="$rainy(rate: 1500)"     -> Physical particle precipitation
3datmos="$sandstorm"             -> Turbulent dust wave emitter
3datmos="$nebula(color: #6366f1)"-> Deep space cosmic gas field

<!-- Particle & Emitter Types -->
<hx-emitter type="$burn">     -> Upward buoyant fire flame particles
<hx-emitter type="$explode">  -> High-velocity radial shockwave particles
<hx-emitter type="$zap">      -> High-frequency electric arc discharges
<hx-emitter type="$splash">   -> Gravity-accelerated liquid droplets
<hx-emitter type="$slime">    -> Viscous fluid dripping & splatter
```

---

## 🏁 Summary for Developers & AI Agents

1. **Keep it declarative**: Use HTML components and `.mx` spatial grammar.
2. **Keep it functional**: Implement math & simulation algorithms in `.fx` files.
3. **Synchronize with hypermedia**: Mount via `HTMXUI.directive('3d')` and sync with `HxBolt.ticker`.
4. **Deploy lean**: Standalone bundle `dist/htmfx.js` is only **~17.6 KB gzipped**.

*HyperFX is maintained by [hyperlibs](https://github.com/hyperlibs).*
