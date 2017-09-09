import {
    CHANGE_ROUTE,
} from '../event.js';

export function changeRoute(path) {
    return {
        type: CHANGE_ROUTE,
        path,
    };
}
