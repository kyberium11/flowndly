// Vercel serverless function entry point
import app from './app.js';
import appConfig from '@/config/app.js';
import logger from '@/helpers/logger.js';

// Vercel serverless function export
export default app;

// For local development
if (process.env.NODE_ENV !== 'production') {
  const port = process.env.PORT || 3000;
  app.listen(port, () => {
    logger.info(`Server is listening on port ${port}`);
  });
}
