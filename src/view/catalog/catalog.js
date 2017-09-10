import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './catalog-styles';
import { PreText } from './pre-text';
import { PreImage } from './pre-image';

function renderItems(itemArray) {
  return itemArray.map((item) => {
    if (item.html) {
      return (
        <PreText
          key={item.title}
          title={item.title}
          author={item.author}
          date={item.date}
          path={item.path}
          html={item.html}
        />
      );

    } else if (preview.image) {
      return (
        <PreImage
          key={item.title}
          title={item.title}
          author={item.author}
          date={item.date}
          path={item.path}
          image={item.image}
        />
      );

    } else {
      return (
        <PreText
          key={item.title}
          title={item.title}
          author={item.author}
          date={item.date}
          html="......"
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
