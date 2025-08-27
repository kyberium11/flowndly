import { createRequire } from 'module';
import { register } from 'node:module';
import { pathToFileURL } from 'node:url';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Register the alias loader
const aliasLoaderPath = path.join(__dirname, 'packages/backend/alias-loader.mjs');
register(aliasLoaderPath, pathToFileURL('./'));

// Set up environment variables for Vercel
process.env.NODE_ENV = process.env.NODE_ENV || 'production';
process.env.APP_ENV = process.env.APP_ENV || 'production';
process.env.PORT = process.env.PORT || '3000';

// Import and start the server
import('./packages/backend/src/server.js').catch(console.error);
