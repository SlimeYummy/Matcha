import * as C from '../../styles-const';

export default {
  wrap: {
    '&:hover': {
      cursor: 'pointer',
    },
    '&:active': {
      cursor: 'pointer',
    }
  },

  meta: {
    width: '100%',
    padding: `5% 5% 0 5%`,
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
    marginRight: C.LINE_HEIGHT_1,
  },

  date: {
    display: 'inline-flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
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
      width: `48%`,
      height: `${C.LINE_HEIGHT * 17}rem`,
      marginBottom: '4%',
    }
  }
};
