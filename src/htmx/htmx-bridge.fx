/**
 * htmFX Hypermedia & HTMX Event Bridge (.fx)
 */

export class HtmxBridge {
  private static observer: MutationObserver | null = null;
  private static isInitialized = false;

  static init(): void {
    if (this.isInitialized) return;
    this.isInitialized = true;

    if (typeof MutationObserver !== 'undefined') {
      this.observer = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
          if (mutation.type === 'childList') {
            mutation.addedNodes.forEach(node => {
              if (node instanceof HTMLElement && node.tagName.toLowerCase().startsWith('hx-')) {
                const customEl = node as any;
                if (typeof customEl.syncSpatialState === 'function') {
                  customEl.syncSpatialState();
                }
              }
            });
          }
        }
      });

      this.observer.observe(document.body, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['xyz', 'rotation', 'scale', '3denv', '3datmos', '3dcamera', 'material', 'color']
      });
    }

    const win = window as any;
    if (win.htmx && typeof win.htmx.defineExtension === 'function') {
      win.htmx.defineExtension('htmfx', {
        onEvent: (name: string, evt: any) => {
          if (name === 'htmx:afterSwap' || name === 'htmx:afterSettle') {
            const target = evt.detail.target;
            if (target) {
              const viewports = target.querySelectorAll('hx-viewport');
              viewports.forEach((vp: any) => {
                if (typeof vp.refreshScene === 'function') {
                  vp.refreshScene();
                }
              });
            }
          }
          return true;
        }
      });
    }

    document.addEventListener('htmx:afterSwap', (e: any) => {
      const target = e.detail?.target;
      if (target) {
        const viewports = target.querySelectorAll?.('hx-viewport') || [];
        viewports.forEach((vp: any) => {
          if (typeof vp.refreshScene === 'function') {
            vp.refreshScene();
          }
        });
      }
    });
  }

  static emitSpatialEvent(element: HTMLElement, eventName: string, detail: any = {}): void {
    const customEvent = new CustomEvent(eventName, {
      bubbles: true,
      cancelable: true,
      detail
    });

    element.dispatchEvent(customEvent);

    const win = window as any;
    if (win.htmx && typeof win.htmx.trigger === 'function') {
      win.htmx.trigger(element, eventName, detail);
    }
  }
}
