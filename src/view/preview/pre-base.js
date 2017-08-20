import Paper from 'material-ui/Paper';
import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './pre-base-styles';

class PreBase extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isHover: false,
    };
    this.onEnter = this.onEnter.bind(this);
    this.onLeave = this.onLeave.bind(this);
  }

  onEnter(event) {
    console.log(event);
    if (this.state.isHover !== true) {
      this.setState({ isHover: true });
    }
  }

  onLeave(event) {
    console.log(event);
    if (this.state.isHover !== false) {
      this.setState({ isHover: false });
    }
  }

  _mergeStyles(name) {
    const { classes, extraClasses } = this.props
    if (extraClasses && extraClasses[name]) {
      return `${classes[name]} ${extraClasses[name]}`;
    } else {
      return classes[name];
    }
  }

  render() {
    const { title, author, date, content } = this.props;
    return (
      <Paper
        className={this._mergeStyles('wrap')}
        elevation={this.state.isHover ? 6 : 2}
        onMouseEnter={this.onEnter}
        onMouseLeave={this.onLeave}
      >
        <div className={this._mergeStyles('meta')}>
          <div className={this._mergeStyles('title')}>{title}</div>
          <div className={this._mergeStyles('author')}>{author}</div>
          <div className={this._mergeStyles('date')}>{date}</div>
        </div>
        <div className={this._mergeStyles('content')}>
          {content}
        </div>
      </Paper>
    );
  }
};

PreBase.propTypes = {
  extraClasses: PropTypes.object,
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  content: PropTypes.node.isRequired,
};

export default withStyles(styles)(PreBase);