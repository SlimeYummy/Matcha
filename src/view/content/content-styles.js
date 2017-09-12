import * as C from '../../styles-const';

export default {
  wrap: {
    color: C.COLOR_TEXT_1,
  },

  title: {
    fontSize: `${C.FONT_SIZE_4}`,
    lineHeight: '1.2',
    marginBottom: `${C.LINE_HEIGHT}rem`,
  },

  meta: {
    marginBottom: `${2 * C.LINE_HEIGHT}rem`,
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
    lineHeight: '1',
    marginRight: C.LINE_HEIGHT_1,
  },

  sign: {
    width: '0.6em',
    height: '0.6em',
    marginRight: '0.5em',
    background: C.COLOR_TEXT_1,
  },

  content: {
    '@global h2': {
      margin: `${2 * C.LINE_HEIGHT}rem 0 ${C.LINE_HEIGHT}rem`,
    },

    '@global h3': {
      margin: `${C.LINE_HEIGHT}rem 0 ${0.5 * C.LINE_HEIGHT}rem`,
    },

    '@global h4': {
      margin: `${C.LINE_HEIGHT}rem 0 ${0.5 * C.LINE_HEIGHT}rem`,
    },

    '@global h5': {
      margin: `${C.LINE_HEIGHT}rem 0 ${0.5 * C.LINE_HEIGHT}rem`,
    },

    '@global p': {
      margin: `${0.5 * C.LINE_HEIGHT}rem 0`,
    },

    '@global img': {
      width: '100%',
    },

    '@global pre': {
      overflowX: 'auto',
      overflowY: 'hidden',
    }
  },
}
