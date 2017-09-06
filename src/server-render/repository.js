import fs from 'fs';
import mdit from 'markdown-it';
import path from 'path';
import yaml from 'js-yaml';
import * as C from '../config';

function readFile(path, encoding) {
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

function writeFile(path, data) {
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

export default async function renderer(urlPath) {
  const normUrlPath = path.posix.normalize('/' + urlPath + '/');
  if (normUrlPath === '/') {
    throw new Error(`Invaild path - ${urlPath}`);
  }
  const localPath = `${C.REPOSITORY}${normUrlPath}`;
  const yamlFile = await readFile(`${localPath}meta.yml`, 'utf8');
  const yamlObj = yaml.safeLoad(yamlFile);
  switch (yamlObj.type) {
    case 'markdown':
      return markdownRenderer(yamlObj, localPath);
    case 'html':
      return htmlRenderer(yamlObj, localPath);
    default:
      throw new Error(`Unknown type ${yamlObj.type} - ${urlPath}`);
  }
}

async function markdownRenderer(yamlObj, localPath) {
  const contentFile = yamlObj.content || 'content.md';
  const contentMd = await readFile(`${localPath}${contentFile}`, 'utf8');
  const markdown = mdit({
    html: true,
    langPrefix: 'lang-',
  });
  const contentHtml = markdown.render(contentMd);
  return {
    title: yamlObj.title,
    author: yamlObj.author,
    date: yamlObj.date,
    html: contentHtml
  };
}

async function htmlRenderer(yamlObj, localPath) {

}
