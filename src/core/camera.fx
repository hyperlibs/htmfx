/**
 * htmFX Camera Controllers (.fx)
 */

import { Vector3, Matrix4 } from './math.fx';

export type CameraMode = 'orbit' | 'first_person' | 'third_person' | 'cinematic' | 'fly';

export class Camera {
  position: Vector3;
  target: Vector3;
  up: Vector3;
  fov: number;
  aspect: number;
  near: number;
  far: number;
  mode: CameraMode;

  viewMatrix: Matrix4;
  projectionMatrix: Matrix4;

  orbitRadius: number = 25.0;
  orbitTheta: number = 0.5;
  orbitPhi: number = 0.4;
  cinematicTime: number = 0;
  yaw: number = 0;
  pitch: number = 0;

  constructor(fov = 60, aspect = 16 / 9, near = 0.1, far = 10000.0) {
    this.position = new Vector3(0, 10, 25);
    this.target = new Vector3(0, 0, 0);
    this.up = new Vector3(0, 1, 0);
    this.fov = fov;
    this.aspect = aspect;
    this.near = near;
    this.far = far;
    this.mode = 'orbit';

    this.viewMatrix = new Matrix4();
    this.projectionMatrix = new Matrix4();

    this.updateProjection();
    this.updateView();
  }

  setMode(mode: CameraMode): void {
    this.mode = mode;
  }

  updateProjection(): void {
    const fovRad = (this.fov * Math.PI) / 180;
    this.projectionMatrix.perspective(fovRad, this.aspect, this.near, this.far);
  }

  updateView(): void {
    this.viewMatrix.lookAt(this.position, this.target, this.up);
  }

  update(dt: number): void {
    if (this.mode === 'orbit') {
      const sinPhi = Math.sin(this.orbitPhi);
      const cosPhi = Math.cos(this.orbitPhi);
      const sinTheta = Math.sin(this.orbitTheta);
      const cosTheta = Math.cos(this.orbitTheta);

      this.position.x = this.target.x + this.orbitRadius * cosPhi * sinTheta;
      this.position.y = this.target.y + this.orbitRadius * sinPhi;
      this.position.z = this.target.z + this.orbitRadius * cosPhi * cosTheta;
    } else if (this.mode === 'cinematic') {
      this.cinematicTime += dt * 0.2;
      const radius = 35.0;
      this.position.x = this.target.x + Math.sin(this.cinematicTime) * radius;
      this.position.y = this.target.y + 12.0 + Math.sin(this.cinematicTime * 0.7) * 4.0;
      this.position.z = this.target.z + Math.cos(this.cinematicTime) * radius;
    }

    this.updateView();
  }

  handleMouseDrag(dx: number, dy: number): void {
    if (this.mode === 'orbit') {
      this.orbitTheta -= dx * 0.006;
      this.orbitPhi += dy * 0.006;
      const maxPhi = Math.PI / 2 - 0.05;
      const minPhi = -Math.PI / 2 + 0.05;
      this.orbitPhi = Math.max(minPhi, Math.min(maxPhi, this.orbitPhi));
    } else if (this.mode === 'first_person' || this.mode === 'fly') {
      this.yaw -= dx * 0.004;
      this.pitch = Math.max(-Math.PI / 2 + 0.05, Math.min(Math.PI / 2 - 0.05, this.pitch - dy * 0.004));
      
      const dir = new Vector3(
        Math.sin(this.yaw) * Math.cos(this.pitch),
        Math.sin(this.pitch),
        -Math.cos(this.yaw) * Math.cos(this.pitch)
      );
      this.target.addVectors(this.position, dir);
    }
  }

  handleZoom(deltaY: number): void {
    if (this.mode === 'orbit') {
      this.orbitRadius = Math.max(2.0, Math.min(2000.0, this.orbitRadius + deltaY * 0.05));
    } else if (this.mode === 'first_person' || this.mode === 'fly') {
      const forward = new Vector3().subVectors(this.target, this.position).normalize();
      this.position.add(forward.scale(-deltaY * 0.05));
      this.target.add(forward.scale(-deltaY * 0.05));
    }
  }
}
