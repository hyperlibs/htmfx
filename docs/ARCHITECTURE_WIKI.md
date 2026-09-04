# Architecture Wiki: htmFX (Spatial Computing Companion for htmxUI)

## 1. Executive Summary
`htmFX` is a decoupled, ultra-lightweight declarative 3D, WebGPU, and spatial simulation companion library for `htmxUI`. It eliminates heavy imperative 3D boilerplate (such as 400-line Three.js scripts) in favor of custom declarative HTML elements (`<hx-viewport>`, `<hx-mesh>`, `<hx-particle>`, `<hx-light>`, `<hx-emitter>`, `<hx-terrain>`) and flat `.mx` spatial coordinate grammar.

```
+-------------------------------------------------------------------------+
|                               htmxUI Layer                              |
|   (HxBolt Signals, HxBolt.ticker 120FPS Game Loop, HxForm, HxFlash)    |
+-------------------------------------------------------------------------+
                                    |
            HTMXUI.directive('3d', (el, b) => HtmFX.mount(el, b))
                                    v
+-------------------------------------------------------------------------+
|                               htmFX Layer                               |
|   <hx-viewport 3denv="$space|$outdoor" 3datmos="$foggy" 3dcamera="$orbit">  |
|   <hx-mesh xyz="0, 10, -50" rotation="0, 45deg, 0" material="hologram">  |
+-------------------------------------------------------------------------+
                                    |
            Spatial Physics & Mathematical Solvers (.fx Kernel)
                                    v
+-------------------------------------------------------------------------+
|   1. Volumetric Exponential Fog:  ρ(y) = ρ₀ · e^(-(y - y₀) / H)         |
|   2. Inverse-Square Attenuation:  I(d) = I₀ / (1 + k₁·d + k₂·d²)        |
|   3. Supersonic Ballistics RK4:   F_drag = -0.5·ρ(y)·Cd(M)·A·||v||·v    |
+-------------------------------------------------------------------------+
```

---

## 2. Mathematical Foundations

### 2.1 Volumetric Exponential Height Fog Field
$$\rho(y) = \rho_0 \cdot e^{-\frac{y - y_0}{H}}$$
- **Analytical Optical Depth Integration**:
$$\tau(p_1, p_2) = \int_{0}^{1} \rho(p(t)) \, dt = \frac{\rho_0 H}{|y_2 - y_1|} \left(e^{-\frac{y_1 - y_0}{H}} - e^{-\frac{y_2 - y_0}{H}}\right) \cdot \|p_2 - p_1\|$$
- **Transmittance**: $T(p_1, p_2) = e^{-\tau(p_1, p_2)}$

### 2.2 Inverse-Square Distance Attenuation
$$I(d) = \frac{I_0}{1 + k_1 \cdot d + k_2 \cdot d^2}$$
- Evaluated for point and volume particle emitters ($burn, $explode, $zap, $slime), 3D spatial audio gain curves, and heat haze vertex distortion.

### 2.3 Supersonic Ballistics & Altitude Drag RK4 Solver
$$\vec{F}_{\text{drag}} = -\frac{1}{2} \cdot \rho(y) \cdot C_d(\text{Mach}) \cdot A \cdot \|\vec{v} - \vec{v}_{\text{wind}}\| \cdot (\vec{v} - \vec{v}_{\text{wind}})$$
$$\vec{a}(t, \vec{r}, \vec{v}) = \vec{g} + \frac{\vec{F}_{\text{drag}}}{m}$$
- Integrated via 4th-order Runge-Kutta step (`k1, k2, k3, k4`) with transonic wave drag coefficient curves $C_d(\text{Mach})$.

---

## 3. Flat Spatial Coordinate Grammar (`.mx`)
Flat `.mx` declarations replace nested div trees with direct spatial anchors:
- `@pin[top-left]`, `@pin[top-right]`, `@pin[bottom-left]`, `@pin[bottom-right]`, `@pin[center]`
- `@3d[x, y, z]` for world-space 3D placement.

---

## 4. Directive and Ticker Integration
```typescript
// Directive Registration
HTMXUI.directive('3d', (el, binding) => HtmFX.mount(el, binding));

// 120 FPS Game Ticker Synchronization
HxBolt.ticker.subscribe((timestamp, dt) => {
  // Synchronized frame loop
});
```

---

## 5. Machine-Parseable Diagnostic Telemetry (`.mx`)
HTMFX adheres strictly to the Universal `.mx` format for compiler, physics, and runtime diagnostic emissions:

```text
@model BuildDiagnostic
  code: string
  type: string
  description: string
  culprit: string
  fix_suggestion: string
  timestamp: string

@diag FX-0042
  type: DIRECTIVE_ERROR
  description: Unrecognized atmosphere parameter
  culprit: <hx-viewport 3datmos="$windy(1500m/s)">
  fix_suggestion: Use $windy(Mach 4.3)
  timestamp: 2026-09-04T12:30:00Z
```

