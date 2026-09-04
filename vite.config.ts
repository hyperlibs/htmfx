import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  plugins: [
    {
      name: 'fx-module-loader',
      enforce: 'pre',
      transform(code, id) {
        if (id.endsWith('.fx')) {
          return {
            code,
            map: null
          };
        }
      }
    }
  ],
  esbuild: {
    include: /\.(ts|js|fx)$/,
    loader: 'ts'
  },
  resolve: {
    extensions: ['.fx', '.ts', '.js', '.json']
  },
  build: {
    lib: {
      entry: resolve(__dirname, 'src/index.fx'),
      name: 'htmFX',
      fileName: (format) => `htmfx.${format === 'es' ? 'esm' : format === 'cjs' ? 'cjs' : ''}js`,
      formats: ['es', 'umd', 'cjs']
    },
    rollupOptions: {
      output: {
        exports: 'named',
        globals: {}
      }
    },
    sourcemap: true,
    minify: 'terser'
  },
  server: {
    port: 3000,
    open: true
  }
});
