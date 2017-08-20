export default (theme) => ({
  [theme.breakpoints.down('sm')]: {
    align: { margin: '100px 10% 200px' }
  },

  [theme.breakpoints.up('sm')]: {
    align: { margin: '100px 25% 200px 10%' }
  },
});
