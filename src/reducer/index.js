import { applyMiddleware, createStore, combineReducers } from 'redux';
import thunk from 'redux-thunk';
import data from './data';
import route from './route';

const rootReducer = combineReducers({
  data,
  route,
});

export default function newStore(initState) {
  return createStore(
    rootReducer,
    initState,
    applyMiddleware(thunk)
  );
}
