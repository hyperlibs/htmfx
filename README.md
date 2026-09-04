# htmFX: Declarative 3D, WebGPU & Spatial Simulation Companion for htmxUI

<p align="center">
  <a href="https://github.com/hyperlibs/htmFX">
    <img src="https://img.shields.io/badge/htmFX-v1.0.0-6366f1?style=for-the-badge&logo=webgl&logoColor=white" alt="htmFX Version">
  </a>
  <a href="https://github.com/hyperlibs/htmxUI">
    <img src="https://img.shields.io/badge/htmxUI-Companion-06b6d4?style=for-the-badge" alt="htmxUI Companion">
  </a>
  <a href="https://bundlephobia.com">
    <img src="https://img.shields.io/badge/bundle_size-~17.6KB_gzipped-10b981?style=for-the-badge" alt="Bundle Size">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge" alt="License">
  </a>
</p>

---

## 🚀 Overview

`htmFX` is a lightweight (~17.6KB gzipped), declarative 3D, WebGPU, and spatial simulation engine companion for [`htmxUI`](https://github.com/hyperlibs/htmxUI).

It eliminates 400-line Three.js boilerplate in favor of custom declarative HTML elements (`<hx-viewport>`, `<hx-mesh>`, `<hx-particle>`, `<hx-light>`, `<hx-emitter>`, `<hx-terrain>`) and flat `.mx` spatial coordinate grammar.

📖 **[Read the Full Agentic AI & Developer Wiki](docs/HYPERFX_AGENTIC_WIKI.md)** — In-depth architectural comparison vs Three.js/R3F, WebGPU game blueprints, supersonic RK4 simulator recipes, and vibe architect cheat sheets.

### Instant AAA 3D Scene in 3 Lines of HTML

```html
<script src="/dist/htmfx.js"></script>

<hx-viewport 3denv="$outdoor" 
             3datmos="$foggy(density: 0.06), $windy(15m/s)" 
             3dcamera="$orbit">
  <hx-mesh id="target-mesh" src="/models/drone.gltf" xyz="0, 10, -50"></hx-mesh>
  <hx-particle type="nebula" count="5000" color="#6366f1"></hx-particle>
  <hx-light type="sun" direction="[1, -2, 1]" intensity="1.5"></hx-light>
</hx-viewport>
```

---

## 🧮 Spatial Physics & Mathematical Solvers

All physics equations are implemented in functional `.fx` modules:

### 1. Volumetric Exponential Height Fog Field
$$\rho(y) = \rho_0 \cdot e^{-\frac{y - y_0}{H}}$$
- In valleys ($y = 500\text{m}$), air is dense ($\rho \approx 0.85$).
- On mountain peaks ($y = 2000\text{m}$), air clears ($\rho \approx 0.02$), creating a volumetric sea of clouds below the camera.
- Integrated analytically for ray transmittance: $T(p_1, p_2) = e^{-\tau(p_1, p_2)}$.

### 2. Inverse-Square Distance Attenuation
$$I(d) = \frac{I_0}{1 + k_1 \cdot d + k_2 \cdot d^2}$$
- Applied to `$burn`, `$explode`, `$zap`, spatial 3D audio, and heat haze vertex distortion fields.

### 3. Supersonic Ballistics & Altitude Drag RK4 Solver
$$\vec{F}_{\text{drag}} = -\frac{1}{2} \cdot \rho(y) \cdot C_d(\text{Mach}) \cdot A \cdot \|\vec{v}\| \cdot \vec{v}$$
- Trajectory integrated via 4th-Order Runge-Kutta (RK4) accounting for crosswind shear and material ricochet matrices.

---

## 🌐 Core Directives & Presets

| Environment Preset | Atmosphere Preset | Default Camera | Fog Density | Wind Speed (m/s) | Altitude (m) |
| :--- | :--- | :--- | :---: | :---: | :---: |
| `$space` | `$nebula` | `$orbit` | 0.00 | 0.00 | 1,000,000.0 |
| `$outdoor` | `$foggy` | `$first_person` | 0.08 | 12.50 | 500.0 |
| `$cyberpunk` | `$rainy` | `$cinematic` | 0.04 | 8.00 | 50.0 |
| `$desert` | `$sandstorm` | `$orbit` | 0.15 | 25.00 | 1,200.0 |
| `$dungeon` | `$clear` | `$first_person` | 0.02 | 0.00 | -200.0 |
| `$underwater` | `$clear` | `$fly` | 0.25 | 0.00 | -50.0 |

---

## 🔌 htmxUI Integration

`htmFX` mounts automatically via `HTMXUI.directive`:

```javascript
// Native htmxUI Directive Mounting
HTMXUI.directive('3d', (el, binding) => HtmFX.mount(el, binding));

// 120 FPS High-Frequency Game Ticker Sync
HxBolt.ticker.subscribe((timestamp, dt) => {
  // Real-time synchronization
});
```

---

## 🧪 Testing & Verification

Run the test suite using `bun`:

```bash
bun test
```

Build the standalone distribution bundle:

```bash
bun run scripts/build.ts
```

---

## 📄 License
MIT © [hyperlibs](https://github.com/hyperlibs)
