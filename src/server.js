import express from 'express';
import sourcemap from 'source-map-support';

import * as C from './config';
import { pageRenderer, contentRenderer } from './renderer';

sourcemap.install();

const server = express();

// app resource
server.use('/', express.static('./dev'));
// user resource
server.use('/', express.static(C.REPOSITORY));

server.get('/', async (req, res) => {
  try {
    const html = await pageRenderer.renderer(req.originalUrl);
    res.send(html);
  } catch (err) {
    console.log(err);
    res.status(500).end();
  }
});

server.get('/_/*', async (req, res) => {
  try {
    const data = await contentRenderer.renderer();
    res.send(data);
  } catch (err) {
    console.log(err);
    res.status(500).end();
  }
});

server.listen(3000, () => {
  console.log('Matcha is running at http://localhost:3000.');
});
