import {
  FETCH_DATA_REQUEST,
  FETCH_DATA_SUCCESS,
  FETCH_DATA_FAILURE,
  DISCARD_DATA,
} from '../event.js';

export default function data(state = {
  status: 'init',
  title: '',
  author: '',
  date: '',
  html: '',
  error: '',
}, action) {
  switch (action.type) {
    case FETCH_DATA_REQUEST:
      return {
        ...state,
        state: 'request',
      };
    case FETCH_DATA_SUCCESS:
      return {
        state: 'success',
        title: action.title,
        author: action.author,
        date: action.date,
        html: action.html,
      };
    case FETCH_DATA_FAILURE:
      return {
        state: 'failure',
        error: action.error,
      };
    case DISCARD_DATA:
      return {
        state: 'discard',
        title: '',
        author: '',
        date: '',
        html: '',
        error: '',
      };
    default:
      return state;
  }
}
