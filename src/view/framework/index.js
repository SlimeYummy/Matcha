import React, { Component } from 'react';

import Content from './content';
import SideBar from './side-bar';
import TitleBar from './title-bar';


export default function FrameWork() {
  return (
    <div>
      <TitleBar />
      <SideBar />
      <Content></Content>
    </div>
  );
}
