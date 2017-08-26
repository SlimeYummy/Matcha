export const GLOBAL_CSS = `
html {
  box-sizing: border-box;
  line-height: 1.7;
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
@media (max-width: 511px) { html { font-size: 12px; } }
@media (max-width: 512px) and (max-width: 767px) { html { font-size: 13px; } }
@media (min-width: 768px) and (max-width: 1280px) {
  html { font-size: 14px; }
}
@media (min-width: 1280px) and (max-width: 1600px) {
  html { font-size: 15px; }
}
@media (min-width: 1600px) {
  html { font-size: 16px; }
}`;

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
