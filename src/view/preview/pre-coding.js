import React, { Component } from 'react';
import Paper from 'material-ui/Paper';
import { withStyles } from 'material-ui/styles';

import styles from './pre-coding-styles';

function _PreCoding({
  classes, title, author, date, content
}) {
  return (
    <Paper className={classes.wrap}>
      <div className={classes.meta}>
        <div className={classes.title}>{title}</div>
        <div className={classes.author}>{author}</div>
        <div className={classes.date}>{date}</div>
      </div>
      <div className={classes.content}>{content}</div>
    </Paper>
  );
}

export const PreCoding = withStyles(styles)(_PreCoding);
