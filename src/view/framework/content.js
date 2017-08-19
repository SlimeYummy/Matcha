import { withStyles } from 'material-ui/styles';
import React, { Component } from 'react';

import styles from './content-styles';

function Content({
  classes, children
}) {
  return (
    <div className={classes.align}>
      <div className={classes.inner}>
        {children}
      </div>
    </div>
  );
}

export default withStyles(styles)(Content);
