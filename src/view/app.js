import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { Provider } from 'react-redux';

import FrameWork from './framework';
import { HomePage } from './page';
import { Router } from './route';

export default class App extends Component {
  render() {
    return (
      <Provider store={this.props.store}>
        <FrameWork>
          <Router>
            <HomePage />
          </Router>
        </FrameWork>
      </Provider>
    );
  }
};

App.propTypes = {
  store: PropTypes.object.isRequired,
};
