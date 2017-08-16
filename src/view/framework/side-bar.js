// react
import React, { Component } from 'react';

import css from './side-bar.css';

export default function SideBar() {
  return (
    <div className={css.wrap}>
      <div className={css.nav}>Home</div>
      <div className={css.nav}>Coding</div>
      <div className={css.nav}>Painting</div>
      <div className={css.nav}>Demo</div>
      <div className={css.nav}>About</div>
      <div className={css.link}>
        <img src="./public/pixiv-1.svg" className={css.icon} />
        <img src="./public/github-7.svg" className={css.icon} />
        <img src="./public/email-4.svg" className={css.icon} />
      </div>
    </div>
  );
}
