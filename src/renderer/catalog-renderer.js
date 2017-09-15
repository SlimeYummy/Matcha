import fs from 'fs';
import yaml from 'js-yaml';
import markdownIt from 'markdown-it';
import moment from 'moment';

import * as C from '../config';
import * as file from './file';

export default class CatalogRenderer {
  constructor(debug) {
    this._debug = debug;
    this._markdown = markdownIt({
      html: true,
      breaks: true,
    });
  }

  async render(catalogMeta, pathInfo) {
    if (!this._debug && catalogMeta.debug) {
      return {
        type: 'catalog',
        itemArray: [],
      }
    }
    const dirArray = await this._scanInclude(catalogMeta.include, pathInfo);
    const jsonArray = await Promise.all(
      dirArray.map((dirName) => this._makePreview(pathInfo.rootPath, dirName))
    );
    const itemArray = this._processItemArray(jsonArray);
    return {
      type: 'catalog',
      itemArray: itemArray,
    }
  }

  async _scanInclude(includeArray, pathInfo) {
    const resultArray = [];
    for (let i = 0; i < includeArray.length; ++i) {
      const include = includeArray[i];
      const patternPath = file.clearSlash(`./${pathInfo.normPath}/${include}/*/`);
      const matchArray = await file.globFile(patternPath, { cwd: pathInfo.rootPath });
      resultArray.push(
        ...matchArray.map((match) => match.slice(1))
      );
    }
    return resultArray;
  }

  async _makePreview(rootPath, dirName) {
    try {
      const yamlFile = await file.readFile(`${rootPath}/${dirName}/meta.yml`, 'utf-8');
      const yamlObj = yaml.safeLoad(yamlFile);

      if (!this._debug && yamlObj.debug) {
        return null;
      }

      if (yamlObj.preMarkdown) {
        return this._previewMarkdown(yamlObj, dirName);
      } else if (yamlObj.preImage) {
        return this._previewImage(yamlObj, dirName);
      } else {
        return null;
      }

    } catch (err) {
      console.log(err);
    }
  }

  _previewMarkdown(yamlObj, dirName) {
    const preMarkdown = yamlObj.preMarkdown.replace(/\n/g, '\n\n');
    return {
      path: dirName,
      title: yamlObj.title,
      author: yamlObj.author,
      date: yamlObj.date,
      html: this._markdown.render(preMarkdown),
    };
  }

  _previewImage(yamlObj, dirName) {
    return {
      path: dirName,
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
        date: moment(item.date).format('YYYY-MM-DD'),
      }));
    return itemArray;
  }
};
