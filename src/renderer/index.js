import * as C from '../config';
import CacheManager from './cache-manager';
import DataRenderer from './data-renderer';
import PageRenderer from './page-renderer';
import MdRenderer from './md-renderer';

export const pageRenderer = new CacheManager(
  new PageRenderer()
);

export const contentRenderer = new CacheManager(
  new DataRenderer({
    'markdown': new MdRenderer(),
  })
);

