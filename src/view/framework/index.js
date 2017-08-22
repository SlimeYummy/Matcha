import PropTypes from 'prop-types';
import React from 'react';
import { withStyles } from 'material-ui/styles';

import SideBar from './side-bar';
import TitleBar from './title-bar';
import styles from './framework-styles';

function FrameWork({
  classes, children,
}) {
  return (
    <div>
      <TitleBar />
      <SideBar />
      <div className={classes.align}>
        {children}
      </div>
    </div>
  );
}

FrameWork.propTypes = {
  children: PropTypes.object.isRequired,
};

export default withStyles(styles)(FrameWork);
