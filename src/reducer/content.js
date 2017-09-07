import {
  FETCH_CONTENT_REQUEST,
  FETCH_CONTENT_SUCCESS,
  FETCH_CONTENT_FAILURE,
  DISCARD_CONTENT,
} from '../event.js';

export default function content(state = {
  status: 'init',
  content: null,
  error: '',
}, action) {
  switch (action.type) {
    case FETCH_CONTENT_REQUEST:
      return {
        ...state,
        state: 'request',
      };
    case FETCH_CONTENT_SUCCESS:
      return {
        state: 'success',
        content: action.content,
      };
    case FETCH_CONTENT_FAILURE:
      return {
        state: 'failure',
        error: action.error,
      };
    case DISCARD_CONTENT:
      return {
        state: 'discard',
        content: null,
        error: '',
      };
    default:
      return state;
  }
}
