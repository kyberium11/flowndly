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

// Set worker environment
process.env.WORKER = 'true';
process.env.NODE_ENV = process.env.NODE_ENV || 'production';
process.env.APP_ENV = process.env.APP_ENV || 'production';

export default async function handler(req, res) {
  try {
    console.log('🚀 Starting Flowndly worker...');
    
    // Import and run the worker
    const worker = await import('../packages/backend/src/worker.js');
    
    console.log('✅ Worker started successfully');
    res.status(200).json({ 
      message: 'Worker started successfully',
      timestamp: new Date().toISOString(),
      environment: process.env.APP_ENV
    });
  } catch (error) {
    console.error('❌ Worker error:', error);
    res.status(500).json({ 
      error: 'Worker failed to start',
      message: error.message,
      timestamp: new Date().toISOString()
    });
  }
}
