/**
 * htmFX Shader Programs & Materials (.fx)
 */

export interface MaterialOptions {
  color?: [number, number, number, number];
  emissive?: [number, number, number];
  roughness?: number;
  metalness?: number;
  wireframe?: boolean;
  transparent?: boolean;
  opacity?: number;
  shaderType?: 'standard' | 'hologram' | 'particle' | 'fog' | 'wireframe' | 'glow';
}

export class Material {
  color: [number, number, number, number];
  emissive: [number, number, number];
  roughness: number;
  metalness: number;
  wireframe: boolean;
  transparent: boolean;
  opacity: number;
  shaderType: 'standard' | 'hologram' | 'particle' | 'fog' | 'wireframe' | 'glow';

  constructor(options?: MaterialOptions) {
    this.color = options?.color ?? [0.8, 0.8, 0.8, 1.0];
    this.emissive = options?.emissive ?? [0, 0, 0];
    this.roughness = options?.roughness ?? 0.5;
    this.metalness = options?.metalness ?? 0.1;
    this.wireframe = options?.wireframe ?? false;
    this.transparent = options?.transparent ?? false;
    this.opacity = options?.opacity ?? 1.0;
    this.shaderType = options?.shaderType ?? 'standard';
  }
}

export const SHADERS = {
  standardVertex: `#version 300 es
    precision highp float;

    layout(location = 0) in vec3 aPosition;
    layout(location = 1) in vec3 aNormal;
    layout(location = 2) in vec2 aUv;

    uniform mat4 uModelMatrix;
    uniform mat4 uViewMatrix;
    uniform mat4 uProjectionMatrix;
    uniform mat4 uNormalMatrix;

    out vec3 vWorldPosition;
    out vec3 vNormal;
    out vec2 vUv;
    out vec3 vViewPosition;

    void main() {
      vec4 worldPos = uModelMatrix * vec4(aPosition, 1.0);
      vWorldPosition = worldPos.xyz;
      
      vec4 viewPos = uViewMatrix * worldPos;
      vViewPosition = -viewPos.xyz;

      vNormal = normalize((uNormalMatrix * vec4(aNormal, 0.0)).xyz);
      vUv = aUv;

      gl_Position = uProjectionMatrix * viewPos;
    }
  `,

  standardFragment: `#version 300 es
    precision highp float;

    in vec3 vWorldPosition;
    in vec3 vNormal;
    in vec2 vUv;
    in vec3 vViewPosition;

    uniform vec4 uColor;
    uniform vec3 uEmissive;
    uniform float uRoughness;
    uniform float uMetalness;
    uniform float uOpacity;

    // Lighting uniforms
    uniform vec3 uSunDirection;
    uniform vec3 uSunColor;
    uniform vec3 uAmbientLight;

    // Fog uniforms
    uniform float uFogBaseDensity;
    uniform float uFogReferenceAlt;
    uniform float uFogScaleHeight;
    uniform vec3 uFogColor;
    uniform vec3 uCameraPosition;

    out vec4 fragColor;

    float calculateFogTransmittance(vec3 p1, vec3 p2) {
      float dist = length(p2 - p1);
      if (dist <= 0.001) return 1.0;

      float y1 = p1.y;
      float y2 = p2.y;
      float dy = y2 - y1;

      float exp1 = exp(-(y1 - uFogReferenceAlt) / max(1.0, uFogScaleHeight));
      float exp2 = exp(-(y2 - uFogReferenceAlt) / max(1.0, uFogScaleHeight));

      float integral;
      if (abs(dy) < 0.01) {
        integral = uFogBaseDensity * exp1 * dist;
      } else {
        integral = (uFogBaseDensity * uFogScaleHeight / abs(dy)) * abs(exp1 - exp2) * dist;
      }

      return exp(-clamp(integral * 0.005, 0.0, 30.0));
    }

    void main() {
      vec3 N = normalize(vNormal);
      vec3 L = normalize(-uSunDirection);
      vec3 V = normalize(uCameraPosition - vWorldPosition);
      vec3 H = normalize(L + V);

      float NdotL = max(dot(N, L), 0.0);
      vec3 diffuse = uColor.rgb * (uAmbientLight + uSunColor * NdotL);

      float NdotH = max(dot(N, H), 0.0);
      float specPower = mix(128.0, 4.0, uRoughness);
      vec3 specular = uSunColor * pow(NdotH, specPower) * (1.0 - uRoughness) * mix(0.04, 1.0, uMetalness);

      vec3 finalRgb = diffuse + specular + uEmissive;

      float transmittance = calculateFogTransmittance(uCameraPosition, vWorldPosition);
      finalRgb = mix(uFogColor, finalRgb, transmittance);

      fragColor = vec4(finalRgb, uColor.a * uOpacity);
    }
  `,

  hologramFragment: `#version 300 es
    precision highp float;

    in vec3 vWorldPosition;
    in vec3 vNormal;
    in vec2 vUv;

    uniform vec4 uColor;
    uniform vec3 uCameraPosition;
    uniform float uTime;

    out vec4 fragColor;

    void main() {
      vec3 N = normalize(vNormal);
      vec3 V = normalize(uCameraPosition - vWorldPosition);

      float fresnel = pow(1.0 - max(dot(N, V), 0.0), 2.5);
      float scanline = sin(vWorldPosition.y * 30.0 - uTime * 6.0) * 0.5 + 0.5;
      scanline = pow(scanline, 4.0);

      float grid = (mod(vUv.x * 20.0, 1.0) > 0.95 || mod(vUv.y * 20.0, 1.0) > 0.95) ? 0.3 : 0.0;

      vec3 holoColor = uColor.rgb * (fresnel * 1.5 + scanline * 0.4 + grid + 0.1);
      float alpha = clamp(fresnel * 0.8 + scanline * 0.3 + 0.15, 0.0, 0.95);

      fragColor = vec4(holoColor, alpha);
    }
  `,

  particleVertex: `#version 300 es
    precision highp float;

    layout(location = 0) in vec3 aPosition;
    layout(location = 1) in vec4 aColor;
    layout(location = 2) in float aSize;

    uniform mat4 uViewMatrix;
    uniform mat4 uProjectionMatrix;

    out vec4 vColor;

    void main() {
      vColor = aColor;
      vec4 viewPos = uViewMatrix * vec4(aPosition, 1.0);
      gl_Position = uProjectionMatrix * viewPos;
      
      float dist = length(viewPos.xyz);
      gl_PointSize = max(1.0, aSize * (400.0 / max(1.0, dist)));
    }
  `,

  particleFragment: `#version 300 es
    precision highp float;

    in vec4 vColor;
    out vec4 fragColor;

    void main() {
      vec2 coord = gl_PointCoord - vec2(0.5);
      float distSq = dot(coord, coord);
      if (distSq > 0.25) {
        discard;
      }

      float alpha = (1.0 - smoothstep(0.0, 0.25, distSq)) * vColor.a;
      fragColor = vec4(vColor.rgb, alpha);
    }
  `
};
