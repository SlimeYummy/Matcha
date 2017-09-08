import markdownIt from 'markdown-it';
import { readFile } from './file';

export default class MarkdownRenderer {
  constructor() {
    this._markdown = markdownIt({
      html: true,
      langPrefix: 'lang-',
    });
  }

  async render(yamlObj, path) {
    const contentFile = yamlObj.content || 'content.md';
    const mdText = await readFile(`${localPath}${contentFile}`, 'utf8');
    const htmlText = this._markdown.render(mdText);
    return {
      title: yamlObj.title,
      author: yamlObj.author,
      date: yamlObj.date,
      html: htmlText
    };
  }
}