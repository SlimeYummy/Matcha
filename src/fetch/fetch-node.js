import fetch, { Headers, Request, Response } from 'node-fetch';
import path from 'path';
import { HOST } from '../config';

function localUrl(url) {
  if (url.startsWith('//')) {
    return `https:${url}`;
  }

  if (url.startsWith('http')) {
    return url;
  }

  const normPath = path.posix.normalize(`/${url}`);
  return `http://${HOST}${normPath}`;
}

global.fetch = (url, options) => {
  return fetch(localUrl(url), options);
}

global.Headers = Headers;
global.Request = Request;
global.Response = Response;
