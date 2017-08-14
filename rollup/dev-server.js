import devBase from './dev-base';

const devServer = Object.assign({
  entry: './src/server.js',
  dest: './build/server.js',
  external: [
    'events', 'tty', 'util', 'net', 'url', 'http', 'stream', 'crypto',
    'require', 'fs', 'path', 'querystring',
  ],
}, devBase);

export default devServer;
