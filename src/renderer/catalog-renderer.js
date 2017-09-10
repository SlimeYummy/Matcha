import fs from 'fs';
import markdownIt from 'markdown-it';
import moment from 'moment';
import path from 'path';
import yaml from 'js-yaml';
import * as C from '../config';
import { readFile, stat, readdir } from './file';

export default class CatalogRenderer {
  constructor() {
    this._markdown = markdownIt({
      html: true,
      breaks: true,
    });
  }

  async render(catalogMeta, realPath) {
    const includeArray = await this._readInclude(catalogMeta.include, realPath);
    const previewArray = await Promise.all(
      includeArray.map((fileName) => this._preview(fileName))
    );
    const itemArray = this._processItemArray(previewArray);
    return {
      type: 'catalog',
      itemArray: itemArray,
    }
  }

  async _readInclude(includeArray, realPath) {
    const resultArray = [];
    for (let i = 0; i < includeArray.length; ++i) {
      const include = includeArray[i];
      const nameArray = await readdir(`${realPath}${include}`);
      nameArray.forEach((name) => {
        resultArray.push(`${realPath}${include}/${name}/meta.yml`);
      });
    }
    return resultArray;
  }

  async _preview(fileName) {
    try {
      const yamlFile = await readFile(fileName, 'utf-8');
      const yamlObj = yaml.safeLoad(yamlFile);

      if (yamlObj.preMarkdown) {
        return this._preMarkdown(yamlObj);
      } else if (yamlObj.preImage) {
        return this._preImage(yamlObj);
      } else {
        return null;
      }

    } catch (err) {
      console.log(err);
    }
  }

  _preMarkdown(yamlObj) {
    const preMarkdown = yamlObj.preMarkdown.replace(/\n/g, '\n\n');
    return {
      title: yamlObj.title,
      author: yamlObj.author,
      date: yamlObj.date,
      html: this._markdown.render(preMarkdown),
    };
  }

  _preImage(yamlObj) {
    return {
      title: yamlObj.title,
      author: yamlObj.author,
      date: yamlObj.date,
      image: yamlObj.image,
    };
  }

  _processItemArray(previewArray) {
    const itemArray = previewArray
      .filter((item) => !!item)
      .sort((itemA, itemB) => itemB.date - itemA.date)
      .map((item) => ({
        ...item,
        date: moment(item.date).format('YY-MM-DD'),
      }));
    return itemArray;
  }
};
