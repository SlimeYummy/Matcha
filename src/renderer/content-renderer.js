import path from 'path';
import yaml from 'js-yaml';
import { readFile } from './file';

export default class ContentRenderer {
  constructor(rootPath) {
    this._rootPath = rootPath;
    this._rendererMap = new Map();
  }

  addRenderer(type, renderer) {
    if (this._rendererMap.has(type)) {
      throw new Error(`Confilict renderer type ${type}`);
    }
    this._rendererMap.set(type, renderer);
  }

  async render(urlPath) {
    const normUrlPath = path.posix.normalize(`/${urlPath}/`);
    if (normUrlPath === '/') {
      throw new Error(`Invaild path - ${urlPath}`);
    }
    const localPath = `${this._rootPath}${normUrlPath}`;

    const yamlFile = await readFile(`${localPath}/meta.yml`, 'utf8');
    const yamlObj = yaml.safeLoad(yamlFile);

    const subRenderer = this._rendererMap.get(yamlObj.type);
    if (!subRenderer) {
      throw new Error(`Unknown type ${yamlObj.type} - ${urlPath}`);
    }

    return subRenderer.render(yamlObj, localPath);
  }
};
