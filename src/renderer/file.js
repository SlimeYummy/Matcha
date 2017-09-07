import fs from 'fs';

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
