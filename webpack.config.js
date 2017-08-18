const base = {
  resolve: {
    extensions: ['.js', '.jsx']
  },
  module: {
    rules: [
      {
        test: /\.js|jsx$/,
        loader: 'babel-loader',
        exclude: '/node_modules/*',
        query: {
          babelrc: false,
          presets: ['es2015', 'react'],
          plugins: [
            'syntax-decorators',
            'syntax-object-rest-spread',
            'transform-async-to-generator',
            'transform-decorators-legacy',
            'transform-exponentiation-operator',
            'transform-object-assign',
            'transform-object-rest-spread',
            'transform-object-set-prototype-of-to-assign',
            ['transform-runtime', {
              helpers: true,
              polyfill: true,
              regenerator: true,
            }],
          ],
        },
      },
      {
        test: /\.json$/,
        loader: "json-loader",
      },
    ]
  },
};

const client = Object.assign({
  entry: './src/client.js',
  output: {
    path: `${__dirname}/dev`,
    filename: 'client.js',
  },
  target: 'web',
}, base);

const server = Object.assign({
  entry: './src/server.js',
  output: {
    path: `${__dirname}/dev`,
    filename: 'server.js',
  },
  target: 'node',
}, base);

module.exports = [client, server];
