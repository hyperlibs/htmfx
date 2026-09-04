import { plugin } from "bun";

// Polyfill minimal browser DOM globals for headless / bun testing
if (typeof globalThis.HTMLElement === "undefined") {
  (globalThis as any).HTMLElement = class HTMLElement {
    attributes: Record<string, string> = {};
    getAttribute(name: string) { return this.attributes[name] || null; }
    setAttribute(name: string, val: string) { this.attributes[name] = val; }
    hasAttribute(name: string) { return name in this.attributes; }
    closest() { return null; }
    dispatchEvent() { return true; }
  };
}

if (typeof globalThis.customElements === "undefined") {
  (globalThis as any).customElements = {
    get: () => null,
    define: () => {}
  };
}

if (typeof globalThis.document === "undefined") {
  (globalThis as any).document = {
    body: {},
    createElement: () => ({ appendChild: () => {}, setAttribute: () => {} }),
    querySelector: () => null,
    querySelectorAll: () => [],
    addEventListener: () => {}
  };
}

if (typeof globalThis.window === "undefined") {
  (globalThis as any).window = globalThis;
}

plugin({
  name: "fx-loader",
  setup(build) {
    build.onLoad({ filter: /\.fx$/ }, async (args) => {
      const text = await Bun.file(args.path).text();
      return {
        contents: text,
        loader: "ts"
      };
    });
  }
});
