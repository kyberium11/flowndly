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

// Create a simple Express app for Vercel serverless functions
import express from 'express';
import cors from 'cors';

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    environment: process.env.APP_ENV 
  });
});

// Import and start the server
import('./packages/backend/src/server.js')
  .then(() => {
    console.log('✅ Flowndly server started successfully');
  })
  .catch((error) => {
    console.error('❌ Failed to start Flowndly server:', error);
    
    // Fallback response for serverless function
    app.get('*', (req, res) => {
      res.status(500).json({
        error: 'Server initialization failed',
        message: error.message,
        timestamp: new Date().toISOString()
      });
    });
  });

// Start the server
app.listen(port, () => {
  console.log(`🚀 Flowndly server running on port ${port}`);
});

export default app;
