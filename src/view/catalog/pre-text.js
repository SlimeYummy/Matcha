import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import PreBase from './pre-base';
import styles from './pre-text-styles';

function _PreText({
  classes, path, title, author, date, html
}) {
  const newContent = (
    <div>
      <div dangerouslySetInnerHTML={{ __html: html }} />
      <span>Read More>></span>
    </div>
  );
  return (
    <PreBase
      path={path}
      title={title}
      author={author}
      date={date}
      content={newContent}
      extraClasses={classes}
    />
  );
}

_PreText.propsType = {
  path: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  author: PropTypes.string.isRequired,
  date: PropTypes.string.isRequired,
  html: PropTypes.string.isRequired,
};

export const PreText = withStyles(styles)(_PreText);
