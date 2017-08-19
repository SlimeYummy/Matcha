export default (theme) => ({
  [theme.breakpoints.down('sm')]: {
    align: { margin: '50px 10% 0' }
  },

  [theme.breakpoints.up('sm')]: {
    align: { margin: '50px 25% 0 10%' }
  },
});
