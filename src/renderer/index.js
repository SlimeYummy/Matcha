import * as C from '../config';
import ContentRenderer from './content-renderer';
import PageRenderer from './page-renderer';
import MarkdownRenderer from './markdown-renderer';

export const pageRenderer = new PageRenderer();
export const contentRenderer = new ContentRenderer(C.REPOSITORY);
contentRenderer.addRenderer(
  'markdown', new MarkdownRenderer(),
);
