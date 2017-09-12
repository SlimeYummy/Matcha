import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './content-styles';

function _Content({
  classes, data,
}) {
  return (
    <article className={classes.wrap}>
      <h1 className={classes.title}>
        {data.title}
      </h1>
      <div className={classes.meta}>
        <span className={classes.author}>
          <span className={classes.sign} />
          {data.author}
        </span>
        <span className={classes.date}>
          <span className={classes.sign} />
          {data.date}
        </span>
      </div>
      <div className={classes.content} dangerouslySetInnerHTML={{ __html: data.html }} />
    </article>
  );
}

_Content.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Content = withStyles(styles)(_Content);
