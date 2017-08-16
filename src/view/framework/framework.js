// react
import React, { Component } from 'react';

// child component
import TitleBar from './title-bar';
import SideBar from './side-bar';

// css
import css from './framework.css';

export default function FrameWork() {
  return (
    <div>
      <TitleBar />
      <SideBar />
    </div>
  );
}
