import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDirection: 'row',
    minHeigth: `40vh`,
    margin: `${C.LINE_HEIGHT_4} 0`,

    '&:hover': {
      cursor: 'pointer',
    },
    '&:active': {
      cursor: 'pointer',
    }
  },

  meta: {
    width: '36%',
    padding: `${C.LINE_HEIGHT_1} 0.5rem ${C.LINE_HEIGHT_1} ${C.LINE_HEIGHT_1}`,
  },

  title: {
    lineHeight: '1.25',
    fontSize: C.FONT_SIZE_3,
    marginBottom: C.LINE_HEIGHT_3,
  },

  author: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
  },

  date: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    fontSize: C.FONT_SIZE_1,
    marginBottom: C.LINE_HEIGHT_0,
  },

  sign: {
    width: '0.6em',
    height: '0.6em',
    marginRight: '1em',
  },

  content: {
    width: '64%',
  },
};
