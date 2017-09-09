import fs from 'fs';
import markdownIt from 'markdown-it';
import path from 'path';
import yaml from 'js-yaml';
import * as C from '../config';
import { readFile, readdir } from './file';

export default class CatalogRenderer {
  constructor() {
    this._markdown = markdownIt({
      html: true,
    });
  }

  async render(catalogMeta, realPath) {
    const includeArray = await this._readInclude(catalogMeta.include, realPath);
    const previewArray = await Promise.all(
      includeArray.map((fileName) => this._preview(fileName))
    );
    const items = previewArray.filter((preview) => !!preview);
    return {
      type: 'catalog',
      items: items,
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

      if (yamlObj.previewText) {
        return {
          title: yamlObj.title,
          author: yamlObj.author,
          date: yamlObj.date,
          html: this._markdown.render(yamlObj.previewText),
        };

      } else if (yamlObj.previewImage) {
        return {
          title: yamlObj.title,
          author: yamlObj.author,
          date: yamlObj.date,
          image: yamlObj.image,
        };

      } else {
        return null;
      }

    } catch (err) {
      return null;
    }
  }
};
