import {
  FETCH_DATA_REQUEST,
  FETCH_DATA_SUCCESS,
  FETCH_DATA_FAILURE,
  DISCARD_DATA,
} from '../event';

function fetchDataRequest() {
  return {
    type: FETCH_DATA_REQUEST,
  }
}

function fetchDataSuccess(data) {
  return {
    type: FETCH_DATA_SUCCESS,
    data,
  }
}

function fetchDataFailure(error) {
  return {
    type: FETCH_DATA_FAILURE,
    error,
  }
}

export function fetchData(path) {
  return async (dispatch) => {
    try {
      dispatch(fetchDataRequest());

      const response = await fetch(path, {
        method: 'GET',
      });
      if (!response.ok) {
        throw new Error(`fetch ${path} failed`);
      }

      const data = await response.json();
      dispatch(fetchDataSuccess(data));

    } catch (err) {
      dispatch(fetchDataFailure(err.message))
      console.log(err);
    }
  };
}

export function discardData() {
  return {
    type: DISCARD_DATA,
  }
}
