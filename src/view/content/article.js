import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './pre-base-styles';

class _Article {
  componentDidMount() {

  }

  render() {
    const { classes, data } = this.props;
    return (
      <div className={classes.wrap}>
        <h1 className={classes.title}>
          {data.title}
        </h1>
        <div className={classes.meta}>
          <span className={classes.author}>
            {data.author}
          </span>
          <span className={classes.date}>
            {data.date}
          </span>
        </div>
        <div dangerouslySetInnerHTML={{ __html: data.content }} />
      </div>
    );
  }
};

_Article.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Article = withStyles(styles)(_Article);
