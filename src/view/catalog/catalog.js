import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './catalog-styles';
import { PreCoding } from './pre-coding';
import { PrePainting } from './pre-painting';

function renderItems(items) {
  return items.map((item) => {
    if (item.html) {
      return (
        <PreCoding
          title={item.title}
          author={item.author}
          date={item.date}
          content={item.html}
        />
      );

    } else if (preview.image) {
      return (
        <PrePainting
          title={item.title}
          author={item.author}
          date={item.date}
          image={item.image}
        />
      );

    } else {
      return (
        <PreCoding
          title={item.title}
          author={item.author}
          date={item.date}
          content="......"
        />
      );
    }
  });
}

function _Catalog({
  classes, data,
}) {
  return (
    <nav className={classes.wrap}>
      {renderItems(data.items)}
    </nav>
  );
}

_Catalog.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Catalog = withStyles(styles)(_Catalog);
