import path from 'path';
import yaml from 'js-yaml';
import * as C from '../config';
import { readFile } from './file';

export default class DataRenderer {
  constructor(rendererMap) {
    this._rendererMap = new Map();
    for (const type in rendererMap) {
      this._rendererMap.set(type, rendererMap[type]);
    }
  }

  async render(normPath) {
    const realPath = `${C.DATA_PATH}${normPath}`;

    const yamlFile = await readFile(`${realPath}/meta.yml`, 'utf8');
    const yamlObj = yaml.safeLoad(yamlFile);

    const subRenderer = this._rendererMap.get(yamlObj.type);
    if (!subRenderer) {
      throw new Error(`Unknown type ${yamlObj.type} - ${urlPath}`);
    }

    const data = await subRenderer.render(yamlObj, realPath);
    return data;
  }
};
