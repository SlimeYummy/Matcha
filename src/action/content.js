import {
  FETCH_CONTENT_REQUEST,
  FETCH_CONTENT_SUCCESS,
  FETCH_CONTENT_FAILURE,
  DISCARD_CONTENT,
} from '../event.js';

function fetchContentRequest() {
  return {
    type: FETCH_CONTENT_REQUEST,
  }
}

function fetchContentSuccess(content) {
  return {
    type: FETCH_CONTENT_REQUEST,
    content,
  }
}

function fetchContentFailure(error) {
  return {
    type: FETCH_CONTENT_REQUEST,
    error,
  }
}

export function fetchContent(path) {
  return async (dispatch) => {
    try {
      dispatch(fetchContentRequest());

      const url = `/_/${path}`;
      const response = await fetch(path, {
        method: 'GET',
        credentials: 'include',
      });
      if (!response.ok) {
        throw new Error(`fetch ${url} failed`);
      }

      const content = await response.json();
      dispatch(fetchContentSuccess(content));

    } catch (err) {
      dispatch(fetchContentFailure(err.message))
      console.log(err);
    }
  };
}

export function discardContent() {
  return {
    type: DISCARD_CONTENT,
  }
}
