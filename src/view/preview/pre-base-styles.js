import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDirection: 'row',
    margin: `${C.LINE_HEIGHT_3} 0`,

    '&:hover': {
      cursor: 'pointer',
    },
    '&:active': {
      cursor: 'pointer',
    }
  },

  meta: {
    width: '36%',
    padding: C.LINE_HEIGHT_0,
  },

  title: {
    lineHeight: '1.2',
    fontSize: C.FONT_SIZE_3,
    marginBottom: C.LINE_HEIGHT_0,
  },

  author: {
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
  },

  date: {
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
  },

  content: {
    width: '64%',
  },
};
