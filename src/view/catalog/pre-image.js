import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';

import PreBase from './pre-base';
import styles from './pre-image-styles';

function _PreImage({
  classes, path, title, author, date, image
}) {
  const content = (
    <img className={classes.img} src={image} />
  );
  return (
    <PreBase
      path={path}
      title={title}
      author={author}
      date={date}
      content={image}
      extraClasses={classes}
    />
  );
}

_PreImage.propsType = {
  path: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  image: PropTypes.string.isRequired,
};

export const PreImage = withStyles(styles)(_PreImage);
