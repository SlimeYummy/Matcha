import {
  FETCH_DATA_REQUEST,
  FETCH_DATA_SUCCESS,
  FETCH_DATA_FAILURE,
} from '../event.js';

export default function data(state = {
  status: 'init',
  data: null,
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
        data: action.data,
      };
    case FETCH_DATA_FAILURE:
      return {
        state: 'failure',
        error: action.error,
      };
    default:
      return state;
  }
}
