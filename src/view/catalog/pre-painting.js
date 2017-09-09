import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';

import PreBase from './pre-base';
import styles from './pre-painting-styles';

function _PrePainting({
  classes, title, author, date, url
}) {
  const content = (
    <img className={classes.img} src={url} />
  );
  return (
    <PreBase
      title={title}
      author={author}
      date={date}
      content={content}
      extraClasses={classes}
    />
  );
}

_PrePainting.propsType = {
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  url: PropTypes.string.isRequired,
};

export const PrePainting = withStyles(styles)(_PrePainting);
