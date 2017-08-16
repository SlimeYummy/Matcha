// react
import React, { Component } from 'react';
// redux
import { Provider } from 'react-redux';
// react-router
import { Route, Link } from 'react-router-dom';
// material-ui
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';

import FrameWork from '../view/framework';

const About = React.createClass({
  render() {
    return <h3>About</h3>
  }
})

const Inbox = React.createClass({
  render() {
    return (
      <div>
        <h2>Inbox</h2>
        {this.props.children || "Welcome to your Inbox"}
      </div>
    )
  }
})

export const App = ({ store }) => {
  return (
    <Provider store={store}>
      <MuiThemeProvider>
        <Route path="/" component={FrameWork} />
      </MuiThemeProvider>
    </Provider>
  );
}
