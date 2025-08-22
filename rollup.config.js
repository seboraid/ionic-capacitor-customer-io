export default {
  input: 'dist/esm/index.js',
  external: id => !/^[./]/.test(id),
  output: [
    {
      file: 'dist/plugin.js',
      format: 'iife',
      name: 'capacitorIonicCustomerIo',
      globals: {
        '@capacitor/core': 'capacitorExports',
      },
      sourcemap: true,
      inlineDynamicImports: true,
    },
    {
      file: 'dist/plugin.cjs.js',
      format: 'cjs',
      sourcemap: true,
      inlineDynamicImports: true,
    },
  ],
};