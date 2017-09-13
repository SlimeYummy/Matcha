import process from 'process';

export const PORT = process.env.PORT ? parseInt(process.env.PORT) : 3000;
export const HOST = `localhost:${PORT}`;
export const WEB_PATH = process.env.WEB_PATH || './dev';
export const DATA_PATH = process.env.DATA_PATH || '../Pancake/';
export const CACHE_PATH = process.env.CACHE_PATH || './cache/';
