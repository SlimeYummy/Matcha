import { applyMiddleware, createStore, combineReducers } from 'redux';
import thunk from 'redux-thunk';
import content from './content';

const rootReducer = combineReducers({
  content,
});

export default function newStore() {
  return createStore(
    rootReducer,
    applyMiddleware(thunk)
  );
}
