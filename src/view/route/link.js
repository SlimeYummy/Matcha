import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

import { changeRoute } from '../../action/route';
import styles from './link-styles';

export class _Link extends Component {
  constructor(props) {
    super(props);
    this.onClick = this.onClick.bind(this);
  }

  onClick(event) {
    const { changeRoute, to } = this.props;
    event.preventDefault();
    history.pushState(null, null, to);
    changeRoute(to);
  }

  render() {
    const { classes, className } = this.props;
    return (
      <a
        className={`${classes.link} ${className || ''}`}
        href={this.props.to}
        onClick={this.onClick}
      >
        {this.props.children}
      </a>
    );
  }
}

_Link.propTypes = {
  classes: PropTypes.object.isRequired,
  className: PropTypes.string,
  to: PropTypes.string.isRequired,
  children: PropTypes.any,
  changeRoute: PropTypes.func.isRequired,
};

function mapDispatchToProps(dispatch) {
  return {
    changeRoute: bindActionCreators(changeRoute, dispatch),
  };
}

export const Link = connect(null, mapDispatchToProps)(withStyles(styles)(_Link));
