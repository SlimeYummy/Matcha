import highlight from 'highlight.js';
import markdownIt from 'markdown-it';
import katex from 'markdown-it-katex';
import moment from 'moment';

import * as file from './file';

const STATUS_INIT = 1;
const STATUS_H1 = 2;
const STATUS_TABLE = 3;
const STATUS_END = 0;

const REGEX_EMPTY = /^\s*$/m;
const REGEX_H1 = /^\s*#.*$/m;
const REGEX_TABLE = /^\s*[\-\+\*].*$/m;

function removeHeader(mdText) {
  const regexLine = /^.*$/mg;
  let status = STATUS_INIT;
  let ignore = 0;
  for (let idx = 0; idx < 20; ++idx) {
    const match = regexLine.exec(mdText);
    if (!match) {
      break;
    }
    status = statusTransfrom(status, match[0]);
    if (status === STATUS_END) {
      ignore = regexLine.lastIndex;
      break;
    }
    regexLine.lastIndex = regexLine.lastIndex + 1;
  }
  return mdText.slice(ignore);
}

function statusTransfrom(status, line) {
  switch (status) {
    case STATUS_INIT:
      if (REGEX_H1.test(line)) {
        return STATUS_H1;
      } else if (REGEX_TABLE.test(line)) {
        return STATUS_TABLE;
      } else if (REGEX_EMPTY.test(line)) {
        return STATUS_INIT;
      } else {
        return STATUS_END;
      }
    case STATUS_H1:
      if (REGEX_TABLE.test(line)) {
        return STATUS_TABLE;
      } else if (REGEX_EMPTY.test(line)) {
        return STATUS_H1;
      } else {
        return STATUS_END;
      }
    case STATUS_TABLE:
      if (REGEX_TABLE.test(line)) {
        return STATUS_TABLE;
      } else {
        return STATUS_END;
      }
    default:
      return STATUS_END;
  }
}

export default class MarkdownRenderer {
  constructor(debug) {
    this._debug = debug;
    this._markdown = markdownIt({
      html: true,
      langPrefix: 'lang-',
      highlight: this._highlight,
    });
    this._markdown.use(katex);
  }

  async render(yamlObj, { realPath }) {
    const contentFile = yamlObj.content || 'content.md';
    const mdText = await file.readFile(`${realPath}/${contentFile}`, 'utf8');
    const mdClear = removeHeader(mdText);
    const htmlText = this._markdown.render(mdClear);
    return {
      type: yamlObj.type,
      title: yamlObj.title,
      author: yamlObj.author,
      date: moment(yamlObj.date).format('YYYY-MM-DD'),
      html: htmlText
    };
  }

  _highlight(text, lang) {
    if (lang && highlight.getLanguage(lang)) {
      try {
        return highlight.highlight(lang, text).value;
      } catch (err) {
        console.log(err);
      }
    }
    return ''; // use external default escaping
  }
}
