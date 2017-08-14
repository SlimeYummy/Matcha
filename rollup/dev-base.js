import babel from 'rollup-plugin-babel';
import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import json from 'rollup-plugin-json';
import replace from 'rollup-plugin-replace';

const devBase = {
  format: 'cjs',
  sourceMap: true,
  plugins: [
    babel({ exclude: 'node_modules/**' }),
    nodeResolve({ jsnext: true }),
    commonjs({
      include: 'node_modules/**',
      namedExports: {
        './node_modules/react/react.js':
        ['cloneElement', 'createElement', 'PropTypes', 'Children', 'Component'],
        './node_modules/react-dom/index.js':
        ['render'],
        './node_modules/react-dom/server':
        ['renderToString'],
      }
    }),
    json({
      include: 'node_modules/**',
      preferConst: true,
      indent: '  ',
    }),
    replace({ 'process.env.NODE_ENV': JSON.stringify('development') }),
  ],
};

export default devBase;
