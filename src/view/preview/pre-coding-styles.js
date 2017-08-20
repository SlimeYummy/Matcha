import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDirection: 'row',
    margin: '6.8rem 0', // 4 * C.LINE_HEIGHT_1
  },

  meta: {
    flex: '1 1 auto',
    padding: C.LINE_HEIGHT_0,
    color: 'white',
    background: '#444',
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
    flex: '2 2 auto',
    padding: C.LINE_HEIGHT_0,
    fontSize: C.FONT_SIZE_1,

    '@global p': {
      margin: `${C.LINE_HEIGHT_0} 0`,
    }
  },
};
