import { applyMiddleware, createStore, combineReducers } from 'redux';
import thunk from 'redux-thunk';
import content from './content';
import location from './location';

const rootReducer = combineReducers({
  content,
  location,
});

export default function newStore() {
  return createStore(
    rootReducer,
    applyMiddleware(thunk)
  );
}
