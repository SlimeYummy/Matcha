import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './pre-base-styles'

function _Picture({
  classes, data,
}) {
  const imageArray = data.imageArray.map((image, index) => {
    return (
      <img className={classes.image} src={image} key={index} />
    );
  });

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
      <div className={classes.imageDiv}>
        {imageArray}
      </div>
    </div>
  );
}

_Picture.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Picture = withStyles(styles)(_Picture);
