import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './content-styles';

function _Content({
  classes, data,
}) {
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
      <div dangerouslySetInnerHTML={{ __html: data.html }} />
    </div>
  );
}

_Content.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Content = withStyles(styles)(_Content);
