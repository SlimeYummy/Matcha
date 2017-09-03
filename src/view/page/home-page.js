import { withStyles } from 'material-ui/styles';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import styles from './home-page-styles';
import { PreCoding, PrePainting } from '../preview';

const TEXT = (
  <div>
    <p>最近想把 FenQi.Engine 的渲染系统从原始的 WebGL 直接调用替换为材质系统。一来是方便合并 DrawCall，二来统一管理 WebGL 绘制状态，三来提供一个 JSON 的材质格式。</p>
    <p>为此，比照 WebGL reference card 把涉及绘制管线的每个函数都复习了一遍，整理成本文。</p>
    <p>这个故事告诉我们，第三方软件存在的价值。如果Windows什么都做到的话，那Windows的价格肯定也是系统家现在所有软件加起来那么多。</p>
  </div>
);

class _HomePage extends Component {
  render() {
    const { classes } = this.props;
    return (
      <div className={classes.body}>
        <PreCoding
          title="WebGL 管线全流程及相关函数"
          author="NaNuNoo"
          date="2016-11-13"
          content={TEXT}
        />
        <PreCoding
          title="WebGL 管线"
          author="NaNuNoo"
          date="2016-11-13"
          content={TEXT}
        />
        <PreCoding
          title="函数"
          author="NaNuNoo"
          date="2016-11-13"
          content={TEXT}
        />
        <PrePainting
          title="WebGL 管线全流程及相关函数"
          author="NaNuNoo"
          date="2016-11-13"
          url="./pic.jpg"
        />
        <PreCoding
          title="WebGL 管线"
          author="NaNuNoo"
          date="2016-11-13"
          content={TEXT}
        />
        <PrePainting
          title="数"
          author="NaNuNoo"
          date="2016-11-13"
          url="./b.jpg"
        />
        <PrePainting
          title="WebGL 管线全流程"
          author="NaNuNoo"
          date="2016-11-13"
          url="./2.jpg"
        />
        <PrePainting
          title="WebGL"
          author="NaNuNoo"
          date="2016-11-13"
          url="./c.jpg"
        />
      </div>
    );
  }
};

_HomePage.propTypes = {
  classes: PropTypes.object.isRequired,
};

export const HomePage = withStyles(styles)(_HomePage);
