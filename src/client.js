// react
import React, { Component } from 'react';
import { render } from 'react-dom';

// redux
import { createStore, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';
import rootReducer from './reducer';

// react-router
import { BrowserRouter } from 'react-router-dom';

// material-ui
import injectTapEventPlugin from 'react-tap-event-plugin';

// app
import { App } from './component/app';


document.onreadystatechange = () => {
  if (document.readyState !== 'interactive') {
    return;
  }

  injectTapEventPlugin();

  const store = createStore(
    rootReducer,
    window.__INITIAL_STATE__ || undefined,
    applyMiddleware(thunkMiddleware)
  );

  render((
    <BrowserRouter>
      <App store={store} />
    </BrowserRouter>
  ), document.getElementById('Matcha'));
}
