import React, { Component } from 'react';
import { render } from 'react-dom';

// redux
import { createStore, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';
import { Provider } from 'react-redux';
import rootReducer from './reducer';

// material-ui
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import injectTapEventPlugin from 'react-tap-event-plugin';

// component
// import InjectionPanel from "./component/injectionPanel";
// import LoginPage from "./component/loginPage";

const RE_CHROME_NEWTAB = /http(s)?:\/\/www\.google\.([a-zA-z]{2}|com)(\.[a-zA-z]{2,3})?\/_\/chrome\/newtab/;
const RE_LN2_PAGE = /http(s)?:\/\/\w+(?:\.\w+)?\.ln2\.io/;

document.onreadystatechange = () => {
  if (document.readyState !== 'interactive') {
    return;
  }

  injectTapEventPlugin();

  const store = createStore(
    rootReducer,
    applyMiddleware(thunkMiddleware)
  );

  const body = document.getElementsByTagName('body')[0];
  const content = document.createElement('div');
  body.appendChild(content);

  render((
    <Provider store={store}>
      <MuiThemeProvider>
        <div>
          <a
            href="http://bing.com"
            onClick={(event) => { event.preventDefault(); }}
          >sssssssssss</a>
        </div>
      </MuiThemeProvider>
    </Provider>
  ), content);
}
