// react
import React, { Component } from 'react';

import css from './title-bar.css';

export default function TitleBar() {
  return (
    <div className={css.wrap}>
      <span className={css.logo}>Logo</span>
      <span className={css.space} />
      <span className={css.menu}>Menu</span>
    </div>
  );
}
