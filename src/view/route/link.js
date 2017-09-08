import React, { Component } from 'react';
import PropTypes from 'prop-types';

export class Link extends Component {
  constructor(props) {
    super(props);
    this.onClick = this.onClick.bind(this);
  }

  onClick(event) {
    event.preventDefault();
    history && history.pushState(null, this.to, url);
  }

  render() {
    return (
      <a href={this.to} onClick={this.onClick}>
        {this.props.children}
      </a>
    );
  }
}

Link.propTypes = {
  to: PropTypes.string.isRequired,
  children: PropTypes.any,
};
