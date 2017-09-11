import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import React, { Component } from 'react';
import { render } from 'react-dom';
import injectTapEventPlugin from 'react-tap-event-plugin';
import thunkMiddleware from 'redux-thunk';

import './fetch/fetch-web';
import newStore from './reducer';
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
        <MuiThemeProvider theme={this.props.theme}>
          <App store={this.props.store} />
        </MuiThemeProvider>
      );
    }
  };

  const theme = createMuiTheme({});

  const store = newStore(window.__INITIAL_STATE__);

  render((
    <Client store={store} theme={theme} />
  ), document.getElementById('Matcha'));

}
