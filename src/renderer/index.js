import * as C from '../config';
import CacheManager from './cache-manager';
import CatalogRenderer from './catalog-renderer';
import DataRender from './data-renderer';
import PageRenderer from './page-renderer';
import MdRenderer from './md-renderer';

export const pageRenderer = new CacheManager(
  new PageRenderer()
);

export const dataRenderer = new CacheManager(
  new DataRender({
    'catalog': new CatalogRenderer(),
    'content-md': new MdRenderer(),
  }),
);

