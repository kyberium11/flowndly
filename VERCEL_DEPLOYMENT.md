# 🚀 Vercel Deployment Guide for Flowndly

This guide will help you deploy Flowndly to Vercel with all services (PostgreSQL, Redis, and Worker) connected to each other.

## 📋 Prerequisites

- Vercel account
- GitHub repository connected to Vercel
- External PostgreSQL database (Vercel Postgres, Supabase, PlanetScale, etc.)
- External Redis database (Upstash Redis, Redis Cloud, etc.)

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Vercel App    │    │   PostgreSQL    │    │     Redis       │
│   (Main API)    │◄──►│   Database      │    │   Cache/Queue   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐
│   Vercel Cron   │
│   (Worker)      │
│   Daily @ UTC   │
└─────────────────┘
```

**Note:** Hobby accounts run the worker once daily at midnight UTC. Pro accounts can run more frequently.

## 🔧 Setup Instructions

### 1. Database Setup (PostgreSQL)

Choose one of these options:

#### Option A: Vercel Postgres (Recommended)
1. Go to your Vercel project
2. Navigate to Storage → Create Database → Postgres
3. Choose a plan and region
4. Copy the connection string

#### Option B: Supabase
1. Create a Supabase project
2. Go to Settings → Database
3. Copy the connection string

#### Option C: PlanetScale
1. Create a PlanetScale database
2. Go to Connect → Connect with Prisma
3. Copy the connection string

### 2. Redis Setup

Choose one of these options:

#### Option A: Upstash Redis (Recommended)
1. Go to [Upstash](https://upstash.com/)
2. Create a Redis database
3. Copy the connection string

#### Option B: Redis Cloud
1. Create a Redis Cloud account
2. Create a database
3. Copy the connection string

### 3. Vercel Environment Variables

Set these environment variables in your Vercel project:

```bash
# Application Configuration
NODE_ENV=production
APP_ENV=production
APP_TITLE=Flowndly
TELEMETRY_ENABLED=false
PROTOCOL=https
PORT=3000
WORKER=false

# Security Keys
APP_SECRET_KEY=OaZcbutL5UN5RoucF9+q6TYNX2HiKMP3Mzh3Hi/0ZDY+c3ch
ENCRYPTION_KEY=zApjqkQOcXdf1q2EaJroT48/hTu1ke9xZq1aHmKvJ3u3Ax4q
WEBHOOK_SECRET_KEY=/MLtwr4VS2AxvHyFNHPdxb11gKZp4G9wKhwcICFWCQEeQbkQ

# Database Configuration (Replace with your actual values)
DATABASE_URL=postgresql://username:password@host:port/database
POSTGRES_HOST=your-postgres-host
POSTGRES_PORT=5432
POSTGRES_DATABASE=your-database-name
POSTGRES_USERNAME=your-username
POSTGRES_PASSWORD=your-password
POSTGRES_ENABLE_SSL=true

# Redis Configuration (Replace with your actual values)
REDIS_URL=redis://username:password@host:port
REDIS_HOST=your-redis-host
REDIS_PORT=6379
REDIS_PASSWORD=your-redis-password
REDIS_USERNAME=default
REDISHOST=your-redis-host
REDISPORT=6379
```

### 4. Worker Setup (Vercel Cron)

Create a Vercel Cron job for the worker:

1. Create `api/cron.js` in your project:

```javascript
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

export default async function handler(req, res) {
  try {
    // Import and run the worker
    const worker = await import('../packages/backend/src/worker.js');
    res.status(200).json({ message: 'Worker started successfully' });
  } catch (error) {
    console.error('Worker error:', error);
    res.status(500).json({ error: 'Worker failed to start' });
  }
}
```

2. Add cron configuration to `vercel.json`:

```json
{
  "crons": [
    {
      "path": "/api/cron",
      "schedule": "0 0 * * *"
    }
  ]
}
```

**Note:** Hobby accounts are limited to daily cron jobs. The worker will run once per day at midnight UTC. Upgrade to Pro plan for more frequent cron jobs.

### 5. Deploy to Vercel

1. Push your code to GitHub
2. Connect your repository to Vercel
3. Set the environment variables in Vercel dashboard
4. Deploy

## 🔍 Troubleshooting

### Common Issues

1. **Module not found errors**: Make sure all files are included in the build
2. **Database connection issues**: Check your DATABASE_URL format
3. **Redis connection issues**: Verify REDIS_URL and credentials
4. **Worker not running**: Check cron job configuration

### Environment Variable Debugging

Add this to your server to debug environment variables:

```javascript
console.log('Environment Variables:');
console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'SET' : 'NOT SET');
console.log('REDIS_URL:', process.env.REDIS_URL ? 'SET' : 'NOT SET');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('APP_ENV:', process.env.APP_ENV);
```

## 📊 Monitoring

- Use Vercel Analytics to monitor performance
- Check Vercel Functions logs for errors
- Monitor database and Redis connections
- Set up alerts for cron job failures

## 🔄 Updates

To update your deployment:

1. Push changes to GitHub
2. Vercel will automatically redeploy
3. Check the deployment logs for any issues
4. Verify all services are connected

## 🆘 Support

If you encounter issues:

1. Check Vercel deployment logs
2. Verify environment variables
3. Test database and Redis connections
4. Review the troubleshooting section above
