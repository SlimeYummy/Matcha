import * as C from '../../styles-const';

export default {
  wrap: {
    position: 'fixed',
    top: '0',
    left: '0',
    zIndex: '1200',
    display: 'flex',
    flexDirection: 'row',
    height: '50px',
    width: '100%',
    background: C.COLOR_BK_1,
  },

  logo: {
    color: C.COLOR_TEXT_1,
  },

  space: {
    flexGrow: 1,
  },

  menu: {
    marginRight: '24px',
  },

  menuIcon: {
    color: C.COLOR_TEXT_1,
  }
};
