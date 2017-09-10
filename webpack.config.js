const Uglify = require("uglifyjs-webpack-plugin");

module.exports = (env) => {
  const prod = !!(env && env.prod);

  const resolve = {
    extensions: ['.js', '.jsx']
  };

  const babelRule = {
    test: /\.js|jsx$/,
    loader: 'babel-loader',
    exclude: /node_modules/,
  };

  const jsonRule = {
    test: /\.json$/,
    loader: "json-loader",
  };

  const client = {
    entry: './src/client.js',
    output: {
      path: prod ? `${__dirname}/prod` : `${__dirname}/dev`,
      filename: 'client.js',
    },
    target: 'web',
    devtool: prod ? '' : 'source-map',
    resolve,
    module: {
      rules: [
        Object.assign({
          query: {
            babelrc: false,
            presets: [['es2015', { modules: false }], 'react'],
            plugins: [
              'transform-runtime',
              'syntax-decorators',
              'syntax-object-rest-spread',
              'transform-async-to-generator',
              'transform-decorators-legacy',
              'transform-exponentiation-operator',
              'transform-object-assign',
              'transform-object-rest-spread',
              'transform-object-set-prototype-of-to-assign',
            ],
          },
        }, babelRule),
        jsonRule,
      ],
    },
    plugins: prod ? [new Uglify()] : [],
  };

  const server = {
    entry: './src/server.js',
    output: {
      path: prod ? `${__dirname}/prod` : `${__dirname}/dev`,
      filename: 'server.js',
    },
    target: 'node',
    devtool: prod ? '' : 'source-map',
    resolve,
    module: {
      rules: [
        Object.assign({
          query: {
            babelrc: false,
            presets: ['react'],
            plugins: [
              'transform-es2015-modules-commonjs',
              'syntax-decorators',
              'syntax-object-rest-spread',
              'transform-async-to-generator',
              'transform-decorators-legacy',
              'transform-object-rest-spread',
            ],
          },
        }, babelRule),
        jsonRule,
      ],
    },
  };

  return [client, server];
}
