import React, { Component } from 'react';
import Paper from 'material-ui/Paper';
import { withStyles } from 'material-ui/styles';

import styles from './pre-painting-styles';

function _PrePainting({
  classes, title, author, date, content
}) {
  return (
    <Paper className={classes.wrap}>
      <div className={classes.meta}>
        <div className={classes.title}>{title}</div>
        <div className={classes.author}>{author}</div>
        <div className={classes.date}>{date}</div>
      </div>
      <img className={classes.content} src="./pic.jpg" />
    </Paper>
  );
}

export const PrePainting = withStyles(styles)(_PrePainting);
