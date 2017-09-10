import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './catalog-styles';
import { PreCoding } from './pre-coding';
import { PrePainting } from './pre-painting';

function renderItems(itemArray) {
  return itemArray.map((item) => {
    if (item.html) {
      return (
        <PreCoding
          key={item.title}
          title={item.title}
          author={item.author}
          date={item.date}
          content={item.html}
        />
      );

    } else if (preview.image) {
      return (
        <PrePainting
          key={item.title}
          title={item.title}
          author={item.author}
          date={item.date}
          image={item.image}
        />
      );

    } else {
      return (
        <PreCoding
          key={item.title}
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
      {renderItems(data.itemArray)}
    </nav>
  );
}

_Catalog.propTypes = {
  classes: PropTypes.object.isRequired,
  data: PropTypes.object.isRequired,
};

export const Catalog = withStyles(styles)(_Catalog);
