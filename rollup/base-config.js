// rollup
import babel from 'rollup-plugin-babel';
import commonjs from 'rollup-plugin-commonjs';
import json from 'rollup-plugin-json';
import nodeResolve from 'rollup-plugin-node-resolve';
import postcss from 'rollup-plugin-postcss';

// postcss
import cssnano from 'cssnano';
import cssnext from 'postcss-cssnext';
import postcssModules from 'postcss-modules';

function rootName(prod) {
  return prod ? 'prod' : 'dev';
}

function fileName(client) {
  return client ? 'client' : 'server';
}

function postcssConfig(client, prod) {
  const cssExportMap = {};

  const plugins = [
    cssnext(),
    postcssModules({
      getJSON(id, exportTokens) {
        cssExportMap[id] = exportTokens;
      }
    }),
  ];
  prod && plugins.push(cssnano());

  const config = postcss({
    plugins,
    sourceMap: !prod,
    extract: `./${rootName(prod)}/style.css`,
    getExportNamed: false,
    getExport(id) { return cssExportMap[id]; },
  });

  return config;
}

export default function baseConfig(client, prod) {
  const plugins = [
    postcssConfig(client, prod),
    babel({ exclude: 'node_modules/**' }),
    nodeResolve({ jsnext: true }),
    json({
      include: 'node_modules/**',
      preferConst: true,
      indent: '  ',
    }),
    commonjs({
      include: 'node_modules/**',
      namedExports: {
        './node_modules/react/react.js':
        ['cloneElement', 'createElement', 'PropTypes', 'Children', 'Component'],
        './node_modules/react-dom/index.js':
        ['render'],
        './node_modules/react-dom/server.js':
        ['renderToString'],
      }
    }),
  ];

  prod && plugins.push(uglify({
    compress: { screw_ie8: true, warnings: false },
    output: { comments: false },
    sourceMap: false,
  }));

  const config = {
    entry: `./src/${fileName(client)}.js`,
    dest: `./${rootName(prod)}/${fileName(client)}.js`,
    format: 'cjs',
    sourceMap: !prod,
    plugins,
  };

  !client && (config.external = [
    'events', 'tty', 'util', 'net', 'url', 'http', 'stream', 'crypto',
    'require', 'fs', 'path', 'querystring', 'module',
  ]);

  return config;
}
