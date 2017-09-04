import * as C from '../../styles-const';

export default {
  wrap: {
    width: '100%',
    color: C.COLOR_TEXT_1,
    marginBottom: C.LINE_HEIGHT_2,

    '&:hover': {
      cursor: 'pointer',
    },

    '&:active': {
      cursor: 'pointer',
    },
  },

  meta: {
    padding: `${0.5 * C.LINE_HEIGHT}rem ${0.75 * C.LINE_HEIGHT}rem`,
    background: C.COLOR_BK_1,
  },

  title: {
    lineHeight: '1.25',
    fontSize: C.FONT_SIZE_3,
  },

  author: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    paddingRight: C.LINE_HEIGHT_1,
    paddingTop: `${0.5 * C.LINE_HEIGHT}rem`,
  },

  date: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    paddingRight: C.LINE_HEIGHT_1,
    paddingTop: `${0.5 * C.LINE_HEIGHT}rem`,
  },

  sign: {
    width: '0.6em',
    height: '0.6em',
    marginRight: '0.5em',
    background: C.COLOR_TEXT_1,
  },

  content: {
    background: '#fff',
  },

  '@media (max-width: 1099.5px)': {
    meta: {
      width: '100%',
    },

    content: {
      width: '100%',
      paddingTop: `${0.5 * C.LINE_HEIGHT}rem`,
    },
  },

  '@media (min-width: 1099.5px)': {
    wrap: {
      display: 'flex',
      flexDirection: 'row',
    },

    meta: {
      display: 'flex',
      flexDirection: 'column',
      width: '36%',
    },

    content: {
      width: '64%',
      paddingLeft: `${0.5 * C.LINE_HEIGHT}rem`,
    },
  },
};
