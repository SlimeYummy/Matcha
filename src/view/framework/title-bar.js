import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import { withStyles } from 'material-ui/styles';
import React, { Component } from 'react';

import { IconMenu } from '../../icon';
import styles from './title-bar-styles';

function TitleBar({
  classes,
}) {
  return (
    <header className={classes.wrap}>
      <img className={classes.logo} src="/public/logo.svg" />
      <span className={classes.space} />
      <IconButton className={classes.menu}>
        <IconMenu className={classes.menuIcon} />
      </IconButton>
    </header>
  );
}

export default withStyles(styles)(TitleBar);
