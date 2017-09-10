export const GLOBAL_CSS = `
html {
  box-sizing: border-box;
  line-height: 1.7;
  min-height: 150%;
}
*, *:before, *:after {
  box-sizing: inherit;
}
html, body, div, h1, h2, h3, h4, h5, h6, p {
  padding: 0;
  margin: 0;
}
p {
  text-align: justify;
  text-justify: ideographic;
}
@media (orientation: portrait) and (max-width: 359.5px),
(orientation: landscape) and (max-width: 599.5px) {
  html { font-size: 12px; }
}
@media (orientation: portrait) and (min-width: 359.5px) and (max-width: 699.5px),
(orientation: landscape) and (min-width: 599.5px) and (max-width: 799.5px) {
  html { font-size: 13px; }
}
@media (orientation: portrait) and (min-width: 699.5px) and (max-width: 899.5px),
(orientation: landscape) and (min-width: 799.5px) and (max-width: 899.5px) {
  html { font-size: 14px; }
}
@media (min-width: 899.5px) and (max-width: 1199.5px) {
  html { font-size: 15px; }
}
@media (min-width: 1199.5px) and (max-width: 1499.5px) {
  html { font-size: 16px; }
}
@media (min-width: 1499.5px) and (max-width: 1799.5px) {
  html { font-size: 17px; }
}
@media (min-width: 1799.5px) {
  html { font-size: 18px; }
}`;

export const FONT_SIZE = 1.0;
export const FONT_SIZE_0 = '0.707rem';
export const FONT_SIZE_1 = '1.000rem';
export const FONT_SIZE_1_5 = '1.2rem';
export const FONT_SIZE_2 = '1.414rem';
export const FONT_SIZE_3 = '2.000rem';
export const FONT_SIZE_4 = '2.828rem';
export const FONT_SIZE_5 = '4.000rem';

export const LINE_HEIGHT = 1.7;
export const LINE_HEIGHT_1 = '1.7rem';
export const LINE_HEIGHT_2 = '3.4rem';
export const LINE_HEIGHT_3 = '5.1rem';
export const LINE_HEIGHT_4 = '6.8rem';

export const SIDE_BAR_WIDTH = '13rem';

export const COLOR_BK_1 = '#f4f1eb';
export const COLOR_BK_2 = '#ffffff';
export const COLOR_TEXT_1 = '#2c3955';
