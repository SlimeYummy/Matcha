import devBase from './dev-base';

const devClient = Object.assign({
  entry: './src/client.js',
  dest: './build/client.js',
}, devBase);

export default devClient;
