import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { Provider } from 'react-redux';
import { Route, Switch, Link } from 'react-router-dom';

import FrameWork from './framework';
import { HomePage } from './page';

export default class App extends Component {
  render() {
    return (
      <Provider store={this.props.store}>
        <FrameWork>
          <Switch>
            <Route path="/" exact component={HomePage} />
            <Route path="/coding" exact component={HomePage} />
            <Route path="/painting" exact component={HomePage} />
            <Route path="/writing" exact component={HomePage} />
            <Route path="/coding/:where" exact component={HomePage} />
            <Route path="/painting/:where" exact component={HomePage} />
            <Route path="/writing/:where" exact component={HomePage} />
            <Route path="/about" exact component={HomePage} />
          </Switch>
        </FrameWork>
      </Provider>
    );
  }
};

App.propTypes = {
  store: PropTypes.object.isRequired,
};
