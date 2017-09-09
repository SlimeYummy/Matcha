import {
  CHANGE_ROUTE,
} from '../event.js';

export default function route(state = {
  path: '',
}, action) {
  switch (action.type) {
    case CHANGE_ROUTE:
      return {
        path: action.path,
      };
    default:
      return state;
  }
}
