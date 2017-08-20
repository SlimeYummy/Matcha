import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import PreBase from './pre-base';
import styles from './pre-coding-styles';

function _PreCoding({
  classes, title, author, date, content
}) {
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

_PreCoding.propsType = {
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  content: PropTypes.node.isRequired,
};

export const PreCoding = withStyles(styles)(_PreCoding);
