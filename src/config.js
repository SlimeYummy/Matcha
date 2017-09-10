import process from 'process';

export const SOURCE_PATH = process.env.PROD ? './prod' : './dev';
export const LOCAL_HOST = 'localhost:3000';
export const DATA_PATH = process.env.DATA_PATH || 'D:/dev/Pancake/';
export const CACHE_PATH = process.env.CACHE_PATH || './cache/';
