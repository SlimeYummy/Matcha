import express from 'express';
import sourcemap from 'source-map-support';

sourcemap.install();
global.fetch = fetch;

import * as C from './config';
import './fetch/fetch-node';
import { pageRenderer, dataRenderer } from './renderer';

const server = express();

// app resource
server.use('/', express.static(C.WEB_PATH));
// user resource
server.use('/', express.static(C.DATA_PATH));

server.get('/data/*', async (req, res) => {
  try {
    const urlPath = req.originalUrl.slice(5);
    const data = await dataRenderer.render(urlPath);
    res.send(data);
  } catch (err) {
    console.log(err);
    res.status(500).end();
  }
});

server.get('/*', async (req, res) => {
  try {
    const html = await pageRenderer.render(req.originalUrl);
    res.send(html);
  } catch (err) {
    console.log(err);
    res.status(500).end();
  }
});

server.listen(C.PORT, () => {
  console.log(`Matcha is running at http://${C.HOST}.`);
});
