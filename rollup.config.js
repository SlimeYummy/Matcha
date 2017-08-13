import babel from 'rollup-plugin-babel';
import commonjs from 'rollup-plugin-commonjs'
import nodeResolve from 'rollup-plugin-node-resolve'
import uglify from 'rollup-plugin-uglify'
import replace from 'rollup-plugin-replace'

var productionConfig = {
  entry: './src/client.jsx',
  dest: './build/client.js',
  format: 'iife',
  plugins: [
    babel({ exclude: 'node_modules/**' }),
    nodeResolve({ jsnext: true }),
    commonjs({
      include: 'node_modules/**',
      namedExports: {
        './node_modules/react/react.js':
        ['cloneElement', 'createElement', 'PropTypes', 'Children', 'Component'],
      }
    }),
    replace({ 'process.env.NODE_ENV': JSON.stringify('production') }),
    uglify({
      compress: { screw_ie8: true, warnings: false },
      output: { comments: false },
      sourceMap: false
    })
  ]
};

var developmentConfig = {
  entry: './src/client.jsx',
  dest: './build/client.js',
  format: 'iife',
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
      }
    }),
    replace({ 'process.env.NODE_ENV': JSON.stringify('development') })
  ]
};

export default developmentConfig;
