import PropTypes from 'prop-types';
import React from 'react';

import Content from './content';
import SideBar from './side-bar';
import TitleBar from './title-bar';
import { PreCoding, PrePainting } from '../preview';

export default function FrameWork({
  children,
}) {
  return (
    <div>
      <TitleBar />
      <SideBar />
      <Content>
        {children}
      </Content>
    </div>
  );
}

FrameWork.propTypes = {
  children: PropTypes.object.isRequired,
};
