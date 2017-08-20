import * as C from '../../styles-const';

export default {
  meta: {
    color: '#ffffff',
    background: '#444444',
    //background: 'url(./a.jpg)',
  },

  sign: {
    background: '#ffffff',
  },

  content: {
    padding: `0 ${C.LINE_HEIGHT_1} 0 ${C.LINE_HEIGHT_0}`,
    fontSize: C.FONT_SIZE_1,

    '@global p': {
      margin: `${C.LINE_HEIGHT_1} 0`,
    }
  },
};
