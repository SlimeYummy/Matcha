import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDirection: 'row',
    marginTop: 'calc(50px + 3vh + 3vw)',
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
      minWidth: '280px',
      maxWidth: '540px',
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

  '@media (min-width: 1099.5px)': {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '3 3 auto' },
    right: { flex: '2 2 auto' },
    center: {
      width: 'calc(300px + 50%)',
      minWidth: '750px',
    }
  },
};
