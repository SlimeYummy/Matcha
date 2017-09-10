import path from 'path';
import * as C from '../config';
import * as file from './file';

const legalSet = new Set();

export default class CacheManager {
  constructor(renderer) {
    this._renderer = renderer;
  }

  async render(rawPath) {
    const normPath = path.posix.normalize(`/${rawPath}/`);
    if (rawPath !== '/' && (normPath === '/' || normPath[0] !== '/')) {
      throw new Error(`Invaild path - ${rawPath}`);
    }

    const realPath = `${C.DATA_PATH}${normPath}`;
    await this._checkPath(realPath);

    return await this._renderer.render(normPath);
  }

  async _checkPath(realPath) {
    if (legalSet.has(realPath)) {
      return true;
    }
    const stats = await file.statFile(realPath);
    if (!stats.isDirectory()) {
      throw new Error(`Invaild path - ${rawPath}`);
    }
    legalSet.add(realPath);
    return true;
  }
}
