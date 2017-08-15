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
import { App } from '../view/app';


function htmlTemplate(html, initialState) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<title>FenQi.IO 分歧点</title>
</head>
<body>
<div id="Matcha">${html}</div>
<script>window.__INITIAL_STATE__=${JSON.stringify(initialState)};</script>
<link rel="stylesheet" type="text/css" href="/style.css"/>
<script src="/client.js"></script>
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
