import * as C from '../../styles-const';

export default {
  wrap: {
    display: 'flex',
    flexDriection: 'row',
    marginTop: '70px',
    marginBottom: '200px',
  },

  [`@media
  (orientation: portrait) and (max-width: 699.5px),
  (orientation: landscape) and (max-width: 799.5px)
  `]: {
    wrap: { width: '100%' },
    left: { flex: '1 1 auto' },
    right: { flex: '1 1 auto' },
    center: {
      width: '88%',
      minWidth: '300px',
      maxWidth: '500px',
    }
  },

  [`@media
  (orientation: portrait) and (min-width: 699.5px) and (max-width: 1023.5px),
  (orientation: landscape) and (min-width: 799.5px) and (max-width: 1023.5px)
  `]: {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '2 2 auto' },
    right: { flex: '1 1 auto' },
    center: {
      width: '85%',
      minWidth: '420px',
      maxWidth: '500px',
    }
  },

  '@media (min-width: 1023.5px) and (max-width: 1439.5px)': {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '2 2 auto' },
    right: { flex: '1 1 auto' },
    center: {
      width: '85%',
      minWidth: '780px',
      maxWidth: '900px',
    }
  },

  '@media (min-width: 1439.5px) and (max-width: 1919.5px)': {
    wrap: { width: `calc(100% - ${C.SIDE_BAR_WIDTH})` },
    left: { flex: '2 2 auto' },
    right: { flex: '1 1 auto' },
    center: {
      width: '80%',
      minWidth: '1170px',
      maxWidth: '1300px',
    }
  },
};
