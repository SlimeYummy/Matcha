import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { changeLocation } from '../../action/location';

class _Router extends Component {
  constructor(props) {
    super(props)
    try {
      window.onpopstate = this.onPopState.bind(this);
    } catch (err) {
      // do nothing here
    }
  }

  onPopState() {
    this.props.changeLocation(location.pathname);
  }

  render() {
    return this.props.children;
  }
};

_Router.propTypes = {
  children: PropTypes.node.isRequired,
  changeLocation: PropTypes.func.isRequired,
};

function mapDispatchToProps(dispatch) {
  return {
    changeLocation: bindActionCreators(changeLocation, dispatch),
  };
}

export const Router = connect(null, mapDispatchToProps)(_Router);
