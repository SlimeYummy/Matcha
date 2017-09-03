import * as C from '../../styles-const';

export default {
  wrap: {
    '&:hover': {
      cursor: 'pointer',
    },
    '&:active': {
      cursor: 'pointer',
    },
    padding: C.LINE_HEIGHT_1,
    color: C.COLOR_TEXT_1,
  },

  meta: {
    width: '100%',
    padding: `${0.5 * C.LINE_HEIGHT}rem ${0.75 * C.LINE_HEIGHT}rem`,
    background: C.COLOR_BK_1,
  },

  title: {
    lineHeight: '1.25',
    fontSize: C.FONT_SIZE_3,
    paddingBottom: `${0.5 * C.LINE_HEIGHT}rem`,
  },

  author: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    paddingRight: C.LINE_HEIGHT_1,
  },

  date: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    paddingRight: C.LINE_HEIGHT_1,
  },

  sign: {
    width: '0.6em',
    height: '0.6em',
    marginRight: '0.5em',
  },

  content: {
    width: '100%',
    paddingTop: `${0.5 * C.LINE_HEIGHT}rem`,
  },

  '@media (max-width: 1099.5px)': {
    wrap: {
      width: '100%',
      marginBottom: C.LINE_HEIGHT_1,
    }
  },

  '@media (min-width: 1099.5px) and (max-width: 1399.5px)': {
    wrap: {
      width: `calc(50% - ${C.LINE_HEIGHT * 0.5}rem)`,
      height: `${C.LINE_HEIGHT * 18}rem`,
      marginBottom: C.LINE_HEIGHT_1,
    }
  },

  '@media (min-width: 1399.5px)': {
    wrap: {
      width: `48% `,
      height: `${C.LINE_HEIGHT * 17}rem`,
      marginBottom: '4%',
    }
  }
};
