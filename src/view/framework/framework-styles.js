import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDriection: 'row',
    marginTop: '70px',
    marginBottom: '200px',
    background: C.COLOR_BK_2,
  },

  [`@media
  (orientation: portrait) and (max-width: 699.5px),
  (orientation: landscape) and (max-width: 799.5px)
  `]: {
    wrap: { width: '100%' },
    left: { flex: '1 1 auto' },
    right: { flex: '1 1 auto' },
    center: {
      width: '85%',
      minWidth: '300px',
      maxWidth: '560px',
    }
  },

  [`@media
  (orientation: portrait) and (min-width: 699.5px) and (max-width: 1099.5px),
  (orientation: landscape) and (min-width: 799.5px) and (max-width: 1099.5px)
  `]: {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '3 3 auto' },
    right: { flex: '2 2 auto' },
    center: {
      width: '80%',
      minWidth: '450px',
      maxWidth: '620px',
    }
  },

  '@media (min-width: 1099.5px) and (max-width: 1399.5px)': {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '3 3 auto' },
    right: { flex: '2 2 auto' },
    center: {
      width: '85%',
      minWidth: '800px',
      maxWidth: '1000px',
    }
  },

  '@media (min-width: 1399.5px)': {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '3 3 auto' },
    right: { flex: '2 2 auto' },
    center: {
      width: '78%',
      minWidth: '1000px',
      maxWidth: '1300px',
    }
  },
};
