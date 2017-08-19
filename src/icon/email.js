import SvgIcon from 'material-ui/SvgIcon';
import React, { Component } from 'react';

export function IconEmail({
  className,
}) {
  return (
    <SvgIcon className={className} viewBox="0 0 1000 1000">
      <path d="M500,10C229.3,10,10,229.3,10,500s219.3,490,490,490c270.7,0,490-219.3,490-490S770.7,10,500,10z M825,266.4l-324.6,273l-324.6-273H825z M173.3,289.8l216.8,183.7L173.3,732.1V289.8z M198.4,732.4l206.8-244.2l95.1,78.1l95.3-80.5l206.8,246.6H198.4z M826.7,732.1L609.8,473.4l216.8-183.7V732.1z" />
    </SvgIcon>
  );
};
