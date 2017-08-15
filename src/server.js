import sourcemap from 'source-map-support';

// express
import express from 'express';

// server render
import { serverRender } from './server-render';

sourcemap.install();

const server = express();
server.use(express.static('dev'));

server.get('/', (req, res) => {
  const html = serverRender(req.url);
  res.send(html);
});

server.listen(3000, () => {
  console.log('Matcha is running at http://localhost:3000.');
})
