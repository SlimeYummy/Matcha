import React, { Component } from 'react';
import IconButton from 'material-ui/IconButton';
import List, { ListItem } from 'material-ui/List';
import { withStyles } from 'material-ui/styles';
import { Link } from 'react-router-dom';

import { IconEmail, IconGithub, IconPixiv } from '../../icon';
import styles from './side-bar-styles.js';

function SideBar({
  classes
}) {
  return (
    <div className={classes.wrap}>
      <LinkList classes={classes} />
      <IconList classes={classes} />
    </div>
  );
}

function LinkList({
  classes
}) {
  return (
    <List className={classes.linkList}>
      <LinKItem classes={classes} text="Home" url="/" />
      <LinKItem classes={classes} text="Coding" url="/coding" />
      <LinKItem classes={classes} text="Painting" url="/painting" />
      <LinKItem classes={classes} text="Writing" url="/writing" />
      <LinKItem classes={classes} text="About" url="/about" />
    </List>
  );
}

function LinKItem({
  text, url, classes
}) {
  return (
    <ListItem className={classes.linkButton} button={true}>
      <Link className={classes.linkLink} to={url}>
        <span className={classes.linkSign} />
        <span className={classes.linkText}>{text}</span>
      </Link>
    </ListItem>
  );
}

function IconList({
  classes
}) {
  return (
    <div className={classes.iconList}>
      <a href="https://github.com/nanunoo">
        <IconButton className={classes.iconButton}>
          <IconGithub className={classes.iconIcon} />
        </IconButton>
      </a>
      <a href="https://pixiv.me/user_gxww5525">
        <IconButton className={classes.iconButton}>
          <IconPixiv className={classes.iconIcon} />
        </IconButton>
      </a>
      <IconButton className={classes.iconButton}>
        <IconEmail className={classes.iconIcon} />
      </IconButton>
    </div>
  );
}

export default withStyles(styles)(SideBar);
