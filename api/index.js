import { createRequire } from 'module';
import { register } from 'node:module';
import { pathToFileURL } from 'node:url';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Register the alias loader
const aliasLoaderPath = path.join(__dirname, '../packages/backend/alias-loader.mjs');
register(aliasLoaderPath, pathToFileURL('./'));

// Set up environment variables for Vercel
process.env.NODE_ENV = process.env.NODE_ENV || 'production';
process.env.APP_ENV = process.env.APP_ENV || 'production';
process.env.PORT = process.env.PORT || '3000';

export default async function handler(req, res) {
  try {
    console.log('🚀 Starting Flowndly API handler...');
    
    // Import the server module
    const serverModule = await import('../packages/backend/src/server.js');
    
    // If the server exports an app, use it
    if (serverModule.default && typeof serverModule.default === 'function') {
      return serverModule.default(req, res);
    }
    
    // Otherwise, return a success response
    res.status(200).json({
      message: 'Flowndly API is running',
      timestamp: new Date().toISOString(),
      environment: process.env.APP_ENV,
      method: req.method,
      url: req.url
    });
    
  } catch (error) {
    console.error('❌ API handler error:', error);
    
    res.status(500).json({
      error: 'Internal server error',
      message: error.message,
      timestamp: new Date().toISOString(),
      environment: process.env.APP_ENV
    });
  }
}
