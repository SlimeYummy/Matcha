// react
import React from 'react';
import { renderToString } from 'react-dom/server';

// react-router
import { StaticRouter } from 'react-router';

// redux
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import rootReducer from '../reducer';

// app
import { App } from '../component/app';


function htmlTemplate(html, initialState) {
  return `<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"></head>
<body>
<div id="Matcha">${html}</div>
<script>window.__INITIAL_STATE__=${JSON.stringify(initialState)};</script>
<script src="/static/bundle.js"></script>
</body>
</html>`;
}

export function serverRender(url) {
  const store = createStore(rootReducer);
  const context = {}

  const html = renderToString(
    <StaticRouter location={url} context={context}>
      <App store={store} />
    </StaticRouter>
  );

  if (context.url) {
    return null;
  } else {
    return htmlTemplate(html);
  }
}
