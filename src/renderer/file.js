import fs from 'fs';
import glob from 'glob';

export function readFile(path, encoding) {
  return new Promise((resolve, reject) => {
    fs.readFile(path, encoding, (err, data) => {
      if (err) {
        return reject(err);
      } else {
        return resolve(data);
      }
    });
  });
}

export function writeFile(path, data) {
  return new Promise((resolve, reject) => {
    fs.writeFile(path, data, (err) => {
      if (err) {
        return reject(err);
      } else {
        return resolve();
      }
    });
  });
}

export function statFile(path) {
  return new Promise((resolve, reject) => {
    fs.stat(path, (err, stats) => {
      if (err) {
        return reject(err);
      } else {
        return resolve(stats);
      }
    });
  });
}

export function globFile(pattern, options = {}) {
  return new Promise((resolve, reject) => {
    glob(pattern, options, (err, nameArray) => {
      if (err) {
        return reject(err);
      } else {
        return resolve(nameArray);
      }
    });
  });
}

const SLASH_REGEXP = /(?:\/|\\)+/g;
export function clearSlash(path) {
  return path.replace(SLASH_REGEXP, '/');
}
