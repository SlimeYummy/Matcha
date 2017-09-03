import * as C from '../../styles-const';

export default {
  meta: {
    color: C.COLOR_TEXT_1,
  },

  sign: {
    background: C.COLOR_TEXT_1,
  },

  content: {
    //padding: `0 5% 5% 5%`,
    fontSize: C.FONT_SIZE_1,
    overflow: 'hidden',

    '@global p': {
      paddingBottom: `${C.LINE_HEIGHT * 0.5}rem`,
    }
  },
};
