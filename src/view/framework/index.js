import React, { Component } from 'react';

import Content from './content';
import SideBar from './side-bar';
import TitleBar from './title-bar';

import { PreCoding, PrePainting } from '../preview';


const TEXT = (
  <div>
    <p>最近想把 FenQi.Engine 的渲染系统从原始的 WebGL 直接调用替换为材质系统。一来是方便合并 DrawCall，二来统一管理 WebGL 绘制状态，三来提供一个 JSON 的材质格式。</p>
    <p>为此，比照 WebGL reference card 把涉及绘制管线的每个函数都复习了一遍，整理成本文。</p>
    <p>阅读本文前，需要对 WebGL 有一定了解。本文按 WebGL 渲染管线顺序，依次描述 WebGL 函数功能，并提供一些复杂操作的伪代码（如：模板测试、深度测试等），可作速查手册。鉴于 OpenGL ES 2.0 和 WebGL 的相似性，OpenGL ES 2.0 亦可参考本文。</p>
  </div>
);

export default function FrameWork() {
  return (
    <div>
      <TitleBar />
      <SideBar />
      <Content>
        <PreCoding
          title="WebGL 管线全流程及相关函数"
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
      </Content>
    </div>
  );
}
