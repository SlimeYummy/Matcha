import * as C from '../../styles-const';

export default {
  wrap: {
    height: `${C.LINE_HEIGHT_NUM * 20}rem`,
    width: `calc(50% - ${C.LINE_HEIGHT_1})`,
    marginBottom: C.LINE_HEIGHT_2,

    '&:hover': {
      cursor: 'pointer',
    },
    '&:active': {
      cursor: 'pointer',
    }
  },

  meta: {
    width: '100%',
    padding: `${C.LINE_HEIGHT_1} 0.5rem ${C.LINE_HEIGHT_1} ${C.LINE_HEIGHT_1}`,
  },

  title: {
    lineHeight: '1.25',
    fontSize: C.FONT_SIZE_3,
    marginBottom: C.LINE_HEIGHT_1,
  },

  author: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
    marginRight: C.LINE_HEIGHT_1,
  },

  date: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
    marginRight: C.LINE_HEIGHT_1,
  },

  sign: {
    width: '0.6em',
    height: '0.6em',
    marginRight: '0.5em',
  },

  content: {
    width: '100%',
  },
};
