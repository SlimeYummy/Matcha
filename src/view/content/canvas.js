import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './pre-base-styles'

function _Canvas({
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
      <canvas className={classes.canvas} id="macha-canvas" />
    </div>
  );
}

_Canvas.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Canvas = withStyles(styles)(_Canvas);
