import {
  CHANGE_LOCATION,
} from '../event.js';

export default function content(state = {
  path: '',
}, action) {
  switch (action.type) {
    case CHANGE_LOCATION:
      return {
        path: action.path,
      };
    default:
      return state;
  }
}
