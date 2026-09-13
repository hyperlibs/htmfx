/**
 * htmFX High-Performance WebGL2 Engine Core (.fx)
 */

import { Vector3, Matrix4, Quaternion, Euler } from './math.fx';
import { Camera } from './camera.fx';
import { GeometryData, GeometryBuilder } from './geometry.fx';
import { Material, SHADERS } from './materials.fx';
import { FogField } from '../physics/fog-field.fx';
import { AttenuationSolver } from '../physics/attenuation.fx';

export interface SceneNode {
  id: string;
  position: Vector3;
  rotation: Euler;
  quaternion: Quaternion;
  scale: Vector3;
  worldMatrix: Matrix4;
  localMatrix: Matrix4;
  geometry?: GeometryData;
  material?: Material;
  children: SceneNode[];
  parent?: SceneNode;
  visible: boolean;
  userData?: any;
  glBuffers?: {
    vao: WebGLVertexArrayObject;
    posVbo: WebGLBuffer;
    normVbo: WebGLBuffer;
    uvVbo: WebGLBuffer;
    ibo: WebGLBuffer;
    indexCount: number;
    indexType: number;
  };
}

export interface ParticleEmitterInstance {
  type: string;
  count: number;
  positions: Float32Array;
  velocities: Float32Array;
  colors: Float32Array;
  sizes: Float32Array;
  lifetimes: Float32Array;
  origin: Vector3;
  color: [number, number, number, number];
  rate: number;
  speed: number;
  glBuffers?: {
    vao: WebGLVertexArrayObject;
    posVbo: WebGLBuffer;
    colVbo: WebGLBuffer;
    sizeVbo: WebGLBuffer;
  };
}

export class Engine {
  canvas: HTMLCanvasElement;
  gl: WebGL2RenderingContext;
  camera: Camera;
  fogField: FogField;
  attenuation: AttenuationSolver;

  rootNode: SceneNode;
  particleEmitters: ParticleEmitterInstance[] = [];

  sunDirection: Vector3 = new Vector3(1, -2, 1).normalize();
  sunColor: [number, number, number] = [1.0, 0.95, 0.85];
  ambientLight: [number, number, number] = [0.15, 0.18, 0.25];
  clearColor: [number, number, number, number] = [0.03, 0.05, 0.08, 1.0];

  programs: {
    standard?: WebGLProgram;
    hologram?: WebGLProgram;
    particle?: WebGLProgram;
  } = {};

  isRunning: boolean = false;
  animationFrameId: number = 0;
  lastTime: number = 0;
  totalTime: number = 0;

  constructor(canvas: HTMLCanvasElement) {
    this.canvas = canvas;
    const gl = canvas.getContext('webgl2', { antialias: true, alpha: false });
    if (!gl) {
      throw new Error('[htmFX] WebGL2 not supported in this browser environment.');
    }
    this.gl = gl;

    this.camera = new Camera(60, canvas.width / canvas.height);
    this.fogField = new FogField();
    this.attenuation = new AttenuationSolver();

    this.rootNode = this.createNode('root');

    this.initGL();
    this.initShaders();
    this.setupEventListeners();
  }

  createNode(id = 'node'): SceneNode {
    return {
      id,
      position: new Vector3(0, 0, 0),
      rotation: new Euler(0, 0, 0),
      quaternion: new Quaternion(),
      scale: new Vector3(1, 1, 1),
      worldMatrix: new Matrix4(),
      localMatrix: new Matrix4(),
      children: [],
      visible: true
    };
  }

  private initGL(): void {
    const gl = this.gl;
    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LEQUAL);
    gl.enable(gl.CULL_FACE);
    gl.cullFace(gl.BACK);
    gl.enable(gl.BLEND);
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    this.resize();
  }

  private createShaderProgram(vSource: string, fSource: string): WebGLProgram {
    const gl = this.gl;
    const vShader = gl.createShader(gl.VERTEX_SHADER)!;
    gl.shaderSource(vShader, vSource);
    gl.compileShader(vShader);
    if (!gl.getShaderParameter(vShader, gl.COMPILE_STATUS)) {
      console.error('[htmFX] Vertex Shader Error:', gl.getShaderInfoLog(vShader));
    }

    const fShader = gl.createShader(gl.FRAGMENT_SHADER)!;
    gl.shaderSource(fShader, fSource);
    gl.compileShader(fShader);
    if (!gl.getShaderParameter(fShader, gl.COMPILE_STATUS)) {
      console.error('[htmFX] Fragment Shader Error:', gl.getShaderInfoLog(fShader));
    }

    const program = gl.createProgram()!;
    gl.attachShader(program, vShader);
    gl.attachShader(program, fShader);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      console.error('[htmFX] Shader Program Link Error:', gl.getProgramInfoLog(program));
    }

    return program;
  }

  private initShaders(): void {
    this.programs.standard = this.createShaderProgram(SHADERS.standardVertex, SHADERS.standardFragment);
    this.programs.hologram = this.createShaderProgram(SHADERS.standardVertex, SHADERS.hologramFragment);
    this.programs.particle = this.createShaderProgram(SHADERS.particleVertex, SHADERS.particleFragment);
  }

  setupGeometryBuffers(node: SceneNode): void {
    if (!node.geometry) return;
    const gl = this.gl;
    const geom = node.geometry;

    const vao = gl.createVertexArray()!;
    gl.bindVertexArray(vao);

    const posVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, posVbo);
    gl.bufferData(gl.ARRAY_BUFFER, geom.positions, gl.STATIC_DRAW);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);

    const normVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, normVbo);
    gl.bufferData(gl.ARRAY_BUFFER, geom.normals, gl.STATIC_DRAW);
    gl.enableVertexAttribArray(1);
    gl.vertexAttribPointer(1, 3, gl.FLOAT, false, 0, 0);

    const uvVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, uvVbo);
    gl.bufferData(gl.ARRAY_BUFFER, geom.uvs, gl.STATIC_DRAW);
    gl.enableVertexAttribArray(2);
    gl.vertexAttribPointer(2, 2, gl.FLOAT, false, 0, 0);

    const ibo = gl.createBuffer()!;
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibo);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, geom.indices, gl.STATIC_DRAW);

    const indexType = geom.indices instanceof Uint32Array ? gl.UNSIGNED_INT : gl.UNSIGNED_SHORT;

    gl.bindVertexArray(null);

    node.glBuffers = {
      vao,
      posVbo,
      normVbo,
      uvVbo,
      ibo,
      indexCount: geom.indices.length,
      indexType
    };
  }

  addParticleEmitter(type = 'nebula', count = 2000, color: [number, number, number, number] = [0.4, 0.6, 1.0, 0.8], origin = new Vector3(0, 0, 0)): ParticleEmitterInstance {
    const positions = new Float32Array(count * 3);
    const velocities = new Float32Array(count * 3);
    const colors = new Float32Array(count * 4);
    const sizes = new Float32Array(count);
    const lifetimes = new Float32Array(count);

    const speed = type === 'explode' || type === 'splatter' ? 18.0 : type === 'zap' ? 12.0 : 2.5;

    for (let i = 0; i < count; i++) {
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos(2 * Math.random() - 1);
      const rad = type === 'nebula' ? Math.random() * 40.0 : Math.random() * 1.5;

      positions[i * 3] = origin.x + rad * Math.sin(phi) * Math.cos(theta);
      positions[i * 3 + 1] = origin.y + rad * Math.sin(phi) * Math.sin(theta);
      positions[i * 3 + 2] = origin.z + rad * Math.cos(phi);

      const dirX = Math.sin(phi) * Math.cos(theta);
      const dirY = Math.abs(Math.sin(phi) * Math.sin(theta)) + 0.2;
      const dirZ = Math.cos(phi);

      velocities[i * 3] = dirX * (Math.random() * speed);
      velocities[i * 3 + 1] = dirY * (Math.random() * speed);
      velocities[i * 3 + 2] = dirZ * (Math.random() * speed);

      colors[i * 4] = color[0] * (0.8 + Math.random() * 0.4);
      colors[i * 4 + 1] = color[1] * (0.8 + Math.random() * 0.4);
      colors[i * 4 + 2] = color[2] * (0.8 + Math.random() * 0.4);
      colors[i * 4 + 3] = color[3];

      sizes[i] = 12.0 + Math.random() * 24.0;
      lifetimes[i] = Math.random() * 4.0;
    }

    const gl = this.gl;
    const vao = gl.createVertexArray()!;
    gl.bindVertexArray(vao);

    const posVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, posVbo);
    gl.bufferData(gl.ARRAY_BUFFER, positions, gl.DYNAMIC_DRAW);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);

    const colVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, colVbo);
    gl.bufferData(gl.ARRAY_BUFFER, colors, gl.DYNAMIC_DRAW);
    gl.enableVertexAttribArray(1);
    gl.vertexAttribPointer(1, 4, gl.FLOAT, false, 0, 0);

    const sizeVbo = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER, sizeVbo);
    gl.bufferData(gl.ARRAY_BUFFER, sizes, gl.DYNAMIC_DRAW);
    gl.enableVertexAttribArray(2);
    gl.vertexAttribPointer(2, 1, gl.FLOAT, false, 0, 0);

    gl.bindVertexArray(null);

    const emitter: ParticleEmitterInstance = {
      type,
      count,
      positions,
      velocities,
      colors,
      sizes,
      lifetimes,
      origin,
      color,
      rate: 100,
      speed,
      glBuffers: { vao, posVbo, colVbo, sizeVbo }
    };

    this.particleEmitters.push(emitter);
    return emitter;
  }

  updateParticles(dt: number): void {
    const gl = this.gl;

    for (const emitter of this.particleEmitters) {
      const { count, positions, velocities, colors, lifetimes, origin, type, speed, color } = emitter;

      for (let i = 0; i < count; i++) {
        lifetimes[i] -= dt;

        if (lifetimes[i] <= 0) {
          lifetimes[i] = 1.5 + Math.random() * 2.5;
          positions[i * 3] = origin.x + (Math.random() - 0.5) * 2.0;
          positions[i * 3 + 1] = origin.y + (Math.random() - 0.5) * 0.5;
          positions[i * 3 + 2] = origin.z + (Math.random() - 0.5) * 2.0;

          const theta = Math.random() * Math.PI * 2;
          const phi = Math.random() * Math.PI;

          velocities[i * 3] = Math.sin(phi) * Math.cos(theta) * speed;
          velocities[i * 3 + 1] = (Math.cos(phi) * 0.5 + 1.0) * speed;
          velocities[i * 3 + 2] = Math.sin(phi) * Math.sin(theta) * speed;
        } else {
          const gravityY = type === 'burn' || type === 'flare' ? 2.5 : type === 'splash' || type === 'slime' ? -9.8 : 0.0;
          velocities[i * 3 + 1] += gravityY * dt;

          positions[i * 3] += velocities[i * 3] * dt;
          positions[i * 3 + 1] += velocities[i * 3 + 1] * dt;
          positions[i * 3 + 2] += velocities[i * 3 + 2] * dt;

          const normLife = Math.max(0, lifetimes[i] / 3.0);
          colors[i * 4 + 3] = normLife * color[3];
        }
      }

      if (emitter.glBuffers) {
        gl.bindBuffer(gl.ARRAY_BUFFER, emitter.glBuffers.posVbo);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, positions);

        gl.bindBuffer(gl.ARRAY_BUFFER, emitter.glBuffers.colVbo);
        gl.bufferSubData(gl.ARRAY_BUFFER, 0, colors);
      }
    }
  }

  resize(): void {
    const width = this.canvas.clientWidth || window.innerWidth || 800;
    const height = this.canvas.clientHeight || window.innerHeight || 600;

    if (this.canvas.width !== width || this.canvas.height !== height) {
      this.canvas.width = width;
      this.canvas.height = height;
      this.gl.viewport(0, 0, width, height);
      this.camera.aspect = width / height;
      this.camera.updateProjection();
    }
  }

  start(): void {
    if (this.isRunning) return;
    this.isRunning = true;
    this.lastTime = performance.now();
    const loop = (time: number) => {
      if (!this.isRunning) return;
      const dt = Math.min(0.1, (time - this.lastTime) / 1000.0);
      this.lastTime = time;
      this.totalTime += dt;

      this.update(dt);
      this.render();

      this.animationFrameId = requestAnimationFrame(loop);
    };
    this.animationFrameId = requestAnimationFrame(loop);
  }

  stop(): void {
    this.isRunning = false;
    cancelAnimationFrame(this.animationFrameId);
  }

  tick(dt: number, time?: number): void {
    if (time !== undefined) {
      this.lastTime = time;
    }
    this.totalTime += dt;
    this.update(dt);
    this.render();
  }

  update(dt: number): void {
    this.resize();
    this.camera.update(dt);
    this.updateParticles(dt);
    this.updateTransforms(this.rootNode, new Matrix4().identity());
  }

  updateTransforms(node: SceneNode, parentMatrix: Matrix4): void {
    node.quaternion.setFromEuler(node.rotation);
    node.localMatrix.compose(node.position, node.quaternion, node.scale);
    node.worldMatrix.multiplyMatrices(parentMatrix, node.localMatrix);

    for (const child of node.children) {
      this.updateTransforms(child, node.worldMatrix);
    }
  }

  render(): void {
    const gl = this.gl;
    const [cr, cg, cb, ca] = this.clearColor;
    gl.clearColor(cr, cg, cb, ca);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    this.renderNode(this.rootNode);
    this.renderParticles();
  }

  private renderNode(node: SceneNode): void {
    if (!node.visible) return;

    if (node.geometry && node.glBuffers) {
      const material = node.material ?? new Material();
      const program = material.shaderType === 'hologram' ? this.programs.hologram! : this.programs.standard!;
      const gl = this.gl;

      gl.useProgram(program);

      const uModel = gl.getUniformLocation(program, 'uModelMatrix');
      const uView = gl.getUniformLocation(program, 'uViewMatrix');
      const uProj = gl.getUniformLocation(program, 'uProjectionMatrix');
      const uNormal = gl.getUniformLocation(program, 'uNormalMatrix');

      gl.uniformMatrix4fv(uModel, false, node.worldMatrix.elements);
      gl.uniformMatrix4fv(uView, false, this.camera.viewMatrix.elements);
      gl.uniformMatrix4fv(uProj, false, this.camera.projectionMatrix.elements);

      const normalMatrix = node.worldMatrix.clone().invert();
      gl.uniformMatrix4fv(uNormal, false, normalMatrix.elements);

      const uColor = gl.getUniformLocation(program, 'uColor');
      const uEmissive = gl.getUniformLocation(program, 'uEmissive');
      const uRoughness = gl.getUniformLocation(program, 'uRoughness');
      const uMetalness = gl.getUniformLocation(program, 'uMetalness');
      const uOpacity = gl.getUniformLocation(program, 'uOpacity');
      const uTime = gl.getUniformLocation(program, 'uTime');

      gl.uniform4fv(uColor, material.color);
      if (uEmissive) gl.uniform3fv(uEmissive, material.emissive);
      if (uRoughness) gl.uniform1f(uRoughness, material.roughness);
      if (uMetalness) gl.uniform1f(uMetalness, material.metalness);
      if (uOpacity) gl.uniform1f(uOpacity, material.opacity);
      if (uTime) gl.uniform1f(uTime, this.totalTime);

      const uSunDir = gl.getUniformLocation(program, 'uSunDirection');
      const uSunCol = gl.getUniformLocation(program, 'uSunColor');
      const uAmb = gl.getUniformLocation(program, 'uAmbientLight');
      const uCamPos = gl.getUniformLocation(program, 'uCameraPosition');

      if (uSunDir) gl.uniform3f(uSunDir, this.sunDirection.x, this.sunDirection.y, this.sunDirection.z);
      if (uSunCol) gl.uniform3fv(uSunCol, this.sunColor);
      if (uAmb) gl.uniform3fv(uAmb, this.ambientLight);
      if (uCamPos) gl.uniform3f(uCamPos, this.camera.position.x, this.camera.position.y, this.camera.position.z);

      const uFogDensity = gl.getUniformLocation(program, 'uFogBaseDensity');
      const uFogAlt = gl.getUniformLocation(program, 'uFogReferenceAlt');
      const uFogScale = gl.getUniformLocation(program, 'uFogScaleHeight');
      const uFogCol = gl.getUniformLocation(program, 'uFogColor');

      if (uFogDensity) gl.uniform1f(uFogDensity, this.fogField.config.baseDensity);
      if (uFogAlt) gl.uniform1f(uFogAlt, this.fogField.config.referenceAltitude);
      if (uFogScale) gl.uniform1f(uFogScale, this.fogField.config.scaleHeight);
      if (uFogCol) gl.uniform3fv(uFogCol, this.fogField.config.color);

      gl.bindVertexArray(node.glBuffers.vao);
      gl.drawElements(gl.TRIANGLES, node.glBuffers.indexCount, node.glBuffers.indexType, 0);
      gl.bindVertexArray(null);
    }

    for (const child of node.children) {
      this.renderNode(child);
    }
  }

  private renderParticles(): void {
    if (this.particleEmitters.length === 0) return;
    const gl = this.gl;
    const program = this.programs.particle!;
    gl.useProgram(program);

    const uView = gl.getUniformLocation(program, 'uViewMatrix');
    const uProj = gl.getUniformLocation(program, 'uProjectionMatrix');

    gl.uniformMatrix4fv(uView, false, this.camera.viewMatrix.elements);
    gl.uniformMatrix4fv(uProj, false, this.camera.projectionMatrix.elements);

    gl.depthMask(false);

    for (const emitter of this.particleEmitters) {
      if (emitter.glBuffers) {
        gl.bindVertexArray(emitter.glBuffers.vao);
        gl.drawArrays(gl.POINTS, 0, emitter.count);
      }
    }

    gl.bindVertexArray(null);
    gl.depthMask(true);
  }

  private setupEventListeners(): void {
    let isDragging = false;
    let lastX = 0;
    let lastY = 0;

    this.canvas.addEventListener('pointerdown', (e) => {
      isDragging = true;
      lastX = e.clientX;
      lastY = e.clientY;
    });

    window.addEventListener('pointermove', (e) => {
      if (!isDragging) return;
      const dx = e.clientX - lastX;
      const dy = e.clientY - lastY;
      lastX = e.clientX;
      lastY = e.clientY;
      this.camera.handleMouseDrag(dx, dy);
    });

    window.addEventListener('pointerup', () => {
      isDragging = false;
    });

    this.canvas.addEventListener('wheel', (e) => {
      e.preventDefault();
      this.camera.handleZoom(e.deltaY);
    }, { passive: false });
  }
}
