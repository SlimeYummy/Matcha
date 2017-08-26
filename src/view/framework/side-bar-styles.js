import * as C from '../../styles-const';

export default {
  wrap: {
    position: 'fixed',
    top: '0',
    right: '0',
    zIndex: '1000',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    height: '100%',
    background: '#DDDDDD',
  },

  //
  // LinkList
  //

  linkList: {
    flex: '0 0 auto',
    paddingTop: '50px',
  },

  linkButton: {
    width: '100%',
    paddingLeft: '3rem',
    paddingRight: '3rem',
  },

  linkLink: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    color: 'black',
    fontSize: C.FONT_SIZE_1_5,
    textDecoration: 'none',
  },

  linkSign: {
    width: '0.5em',
    height: '0.5em',
    background: 'black',
    marginRight: '1em',
  },

  linkText: {
  },

  //
  // IconList
  //

  iconList: {
    flex: '0 0 auto',
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    margin: '100px auto 0',
  },

  iconButton: {
    width: '3.6rem',
    height: '3.6rem',
  },

  iconIcon: {
    width: '1.8rem',
    height: '1.8rem',
  },

  [`@media
  (orientation: portrait) and (max-width: 699.5px),
  (orientation: landscape) and (max-width: 799.5px)
  `]: {
    wrap: {
      display: 'none',
      width: C.SIDE_BAR_WIDTH,
    }
  },

  [`@media
  (orientation: portrait) and (min-width: 699.5px),
  (orientation: landscape) and (min-width: 799.5px)
  `]: {
    wrap: {
      width: C.SIDE_BAR_WIDTH,
    }
  },
};
