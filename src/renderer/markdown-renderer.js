import markdownIt from 'markdown-it';
import { readFile } from './file';

export default class MarkdownRenderer {
  constructor() {
    this._markdown = markdownIt({
      html: true,
      langPrefix: 'lang-',
    });
  }

  async render(yamlObj, { realPath }) {
    const contentFile = yamlObj.content || 'content.md';
    const mdText = await readFile(`${realPath}/${contentFile}`, 'utf8');
    const htmlText = this._markdown.render(mdText);
    return {
      type: yamlObj.type,
      title: yamlObj.title,
      author: yamlObj.author,
      date: yamlObj.date,
      html: htmlText
    };
  }

  _removeHeader() {

  }
}
