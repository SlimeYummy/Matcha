import { blue, red } from 'material-ui/colors';
import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import createPalette from 'material-ui/styles/palette';
import React, { Component } from 'react';
import { render } from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import injectTapEventPlugin from 'react-tap-event-plugin';
import { createStore, applyMiddleware } from 'redux';
import thunkMiddleware from 'redux-thunk';

import rootReducer from './reducer';
import App from './view/app';


window.onload = () => {
  injectTapEventPlugin();

  class Client extends Component {
    componentDidMount() {
      const jssStyles = document.getElementById('jss-server-side');
      if (jssStyles && jssStyles.parentNode) {
        jssStyles.parentNode.removeChild(jssStyles);
      }
    }

    render() {
      return (
        <BrowserRouter>
          <MuiThemeProvider theme={this.props.theme}>
            <App store={this.props.store} />
          </MuiThemeProvider>
        </BrowserRouter>
      );
    }
  };

  const theme = createMuiTheme({
    palette: createPalette({
      primary: blue,
      accent: red,
      type: 'light',
    }),
  });

  const store = createStore(
    rootReducer,
    window.__INITIAL_STATE__ || undefined,
    applyMiddleware(thunkMiddleware)
  );

  render((
    <Client store={store} theme={theme} />
  ), document.getElementById('Matcha'));

}
