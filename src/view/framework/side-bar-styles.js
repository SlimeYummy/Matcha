export default (theme) => ({
  wrapPaper: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    background: theme.palette.primary[500],
  },

  [theme.breakpoints.down('sm')]: {
    wrap: { display: 'none' },
    wrapPaper: { width: '30%' }
  },

  [theme.breakpoints.up('sm')]: {
    wrapPaper: { width: '20%' }
  },

  //
  // LinkList
  //

  linkList: {
    flex: '0 0 auto',

    paddingTop: '50px',
  },

  linkButton: {
    paddingLeft: '25%',
  },

  linkLink: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',

    color: 'black',
    fontSize: '20px',
    textDecoration: 'none',
  },

  linkSign: {
    width: '0.6em',
    height: '0.6em',
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

    margin: '100px 20% 0',
  },

  iconButton: {
    width: '56px',
    height: '56px',
  },

  iconIcon: {
    width: '28px',
    height: '28px',
  }
});
