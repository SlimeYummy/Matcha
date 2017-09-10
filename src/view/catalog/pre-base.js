import Paper from 'material-ui/Paper';
import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import { Link } from '../route';
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
    if (this.state.isHover !== true) {
      this.setState({ isHover: true });
    }
  }

  onLeave(event) {
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
    const { title, path, author, date, content, classes } = this.props;
    return (
      <article
        className={classes.wrap}
        elevation={this.state.isHover ? 6 : 2}
        onMouseEnter={this.onEnter}
        onMouseLeave={this.onLeave}
      >
        <Link className={classes.wrapLink} to={path}>
          <div className={classes.meta}>
            <div className={classes.title}>{title}</div>
            <span className={classes.author}>
              <span className={classes.sign} />
              {author}
            </span>
            <span className={classes.date}>
              <span className={classes.sign} />
              {date}
            </span>
          </div>
          <div className={this._mergeStyles('content')}>
            {content}
          </div>
        </Link>
      </article>
    );
  }
};

PreBase.propTypes = {
  extraClasses: PropTypes.object,
  path: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  content: PropTypes.node.isRequired,
  color: PropTypes.string,
};

export default withStyles(styles)(PreBase);
