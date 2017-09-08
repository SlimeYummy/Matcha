import {
  CHANGE_LOCATION,
} from '../event.js';

export function changeLocation(path) {
  return {
    type: CHANGE_LOCATION,
    path,
  };
}
