import { create } from 'jss';
import preset from 'jss-preset-default';
import { blue, red } from 'material-ui/colors';
import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import createGenerateClassName from 'material-ui/styles/createGenerateClassName';
import createPalette from 'material-ui/styles/palette';
import { renderToString } from 'react-dom/server';
import React from 'react';
import { JssProvider, SheetsRegistry } from 'react-jss';
import { Provider } from 'react-redux';
import { StaticRouter } from 'react-router';
import { createStore } from 'redux';

import rootReducer from '../reducer';
import { GLOBAL_CSS } from '../styles-const';
import App from '../view/app';

export default class PageRenderer {
  _htmlTemplate(html, css, initialState) {
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
<style>${GLOBAL_CSS}</style>
<style id="jss-server-side">${css}</style>
<script>window.__INITIAL_STATE__=${JSON.stringify(initialState)};</script>
<script src="/client.js"></script>
</body>
</html>`;
  }

  async renderer(url) {
    const context = {};
    const store = createStore(rootReducer);

    const theme = createMuiTheme({
      palette: createPalette({
        primary: blue,
        accent: red,
        type: 'light',
      }),
    });

    const sheetsRegistry = new SheetsRegistry();
    const jss = create(preset());
    jss.options.createGenerateClassName = createGenerateClassName;

    const html = renderToString(
      <JssProvider registry={sheetsRegistry} jss={jss}>
        <MuiThemeProvider theme={theme} sheetsManager={new Map()}>
          <StaticRouter location={url} context={context}>
            <App store={store} />
          </StaticRouter>
        </MuiThemeProvider>
      </JssProvider>
    );
    const css = sheetsRegistry.toString()

    if (context.url) {
      return null;
    }
    return this._htmlTemplate(html, css);
  }
}
