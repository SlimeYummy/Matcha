import * as C from '../../styles-const';

export default {
  meta: {
    color: '#444444',
  },

  sign: {
    background: '#444444',
  },

  content: {
    padding: `0 5% 5% 5%`,
    fontSize: C.FONT_SIZE_1,
    overflow: 'hidden',

    '@global p': {
      paddingTop: C.LINE_HEIGHT_1,
    }
  },
};
