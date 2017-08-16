// react
import React, { Component } from 'react';

import css from './title-bar.css';

export default function TitleBar() {
  return (
    <div className={css.wrap}>
      <img src="./public/logo.svg" className={css.logo} />
      <span className={css.space} />
      <img src="./public/menu-5.svg" className={css.menu} />
    </div>
  );
}
