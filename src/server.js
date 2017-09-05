import sourcemap from 'source-map-support';
sourcemap.install();
import * as C from './config';

// express
import express from 'express';

// server render
import { serverRender } from './server-render';

const server = express();

// app resource
server.use('/', express.static('./dev'));
// user resource
server.use('/', express.static(C.REPOSITORY));

server.get('/', (req, res) => {
  const html = serverRender(req.url);
  res.send(html);
});

server.get('/_/', (req, res) => {

});

server.listen(3000, () => {
  console.log('Matcha is running at http://localhost:3000.');
});
