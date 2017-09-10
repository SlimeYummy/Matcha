import path from 'path';
import yaml from 'js-yaml';

import * as file from './file';

export default class DataRenderer {
  constructor(rootPath, rendererMap) {
    this._rootPath = path.posix.normalize(`${rootPath}/`);
    this._rendererMap = new Map();
    for (const type in rendererMap) {
      this._rendererMap.set(type, rendererMap[type]);
    }
  }

  async render(normPath) {
    const realPath = file.clearSlash(`${this._rootPath}/${normPath}`);

    const yamlFile = await file.readFile(`${realPath}/meta.yml`, 'utf8');
    const yamlObj = yaml.safeLoad(yamlFile);

    const subRenderer = this._rendererMap.get(yamlObj.type);
    if (!subRenderer) {
      throw new Error(`Unknown type ${yamlObj.type} - ${urlPath}`);
    }

    const pathInfo = {
      rootPath: this._rootPath,
      normPath,
      realPath,
    };
    const data = await subRenderer.render(yamlObj, pathInfo);
    data.path = normPath;
    return data;
  }
};
