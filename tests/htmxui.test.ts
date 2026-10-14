import { describe, it, expect } from 'vitest';
import { HtmxProDirective, HtmxUIDirective } from '../src/htmxui/htmxui-directive.fx';
import { HxColliderElement } from '../src/elements/hx-collider.fx';
import { Vector3 } from '../src/core/math.fx';

describe('HTMX PRO Directives & Spatial Elements', () => {
  it('mounts 3D directives on elements via HtmxProDirective and HtmxUIDirective', () => {
    const mockEl = {
      tagName: 'DIV',
      classList: { contains: () => false },
      setAttribute: (k: string, v: string) => { (mockEl as any)[k] = v; }
    } as any;

    HtmxProDirective.mount(mockEl, { value: '0, 10, -50' });
    expect(mockEl.xyz).toBe('0, 10, -50');

    const mockEl2 = {
      tagName: 'DIV',
      classList: { contains: () => false },
      setAttribute: (k: string, v: string) => { (mockEl2 as any)[k] = v; }
    } as any;

    HtmxUIDirective.mount(mockEl2, { value: '5, 20, -10' });
    expect(mockEl2.xyz).toBe('5, 20, -10');
  });

  it('evaluates spatial collision detection', () => {
    const collider = new HxColliderElement();
    collider.setAttribute('xyz', '0, 0, 0');
    collider.setAttribute('size', '4, 4, 4');

    expect(collider.checkHit(new Vector3(1, 1, 1))).toBe(true);
    expect(collider.checkHit(new Vector3(10, 10, 10))).toBe(false);
  });
});
