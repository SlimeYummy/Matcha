import * as C from '../../styles-const';

export default {
  meta: {
    color: '#ffffff',
    background: '#444444',
  },

  content: {
    padding: C.LINE_HEIGHT_0,
    fontSize: C.FONT_SIZE_1,

    '@global p': {
      margin: `${C.LINE_HEIGHT_0} 0`,
    }
  },
};
