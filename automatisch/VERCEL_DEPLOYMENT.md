# 🚀 Flowndly Vercel Deployment Guide

## ⚠️ **Important: Vercel Limitations**

Vercel has some limitations that affect Flowndly:

- ❌ **No PostgreSQL support** - Vercel doesn't provide PostgreSQL
- ❌ **No Redis support** - Vercel doesn't provide Redis
- ❌ **Serverless functions** - Limited execution time (30 seconds max)
- ❌ **No persistent storage** - Files are read-only

## 🎯 **Vercel + External Services Solution**

To deploy Flowndly on Vercel, you need external services:

### **Required External Services:**
1. **PostgreSQL Database**: Supabase, PlanetScale, Railway, Neon
2. **Redis Cache**: Upstash Redis, Redis Cloud, Railway Redis
3. **File Storage**: AWS S3, Cloudinary, or similar

## 📋 **Step-by-Step Vercel Deployment**

### **Step 1: Prepare Your Application**

1. **Install Vercel CLI**:
   ```bash
   npm i -g vercel
   ```

2. **Login to Vercel**:
   ```bash
   vercel login
   ```

3. **Navigate to your project**:
   ```bash
   cd automatisch
   ```

### **Step 2: Set Up External Database**

#### **Option A: Supabase (Recommended)**
1. **Go to**: https://supabase.com
2. **Create new project**
3. **Get connection string** from Settings > Database
4. **Note the connection details**

#### **Option B: PlanetScale**
1. **Go to**: https://planetscale.com
2. **Create new database**
3. **Get connection string**
4. **Note the connection details**

### **Step 3: Set Up External Redis**

#### **Option A: Upstash Redis (Recommended)**
1. **Go to**: https://upstash.com
2. **Create new Redis database**
3. **Get connection details**
4. **Note the connection string**

#### **Option B: Redis Cloud**
1. **Go to**: https://redis.com/redis-enterprise-cloud/overview/
2. **Create free account**
3. **Create new database**
4. **Get connection details**

### **Step 4: Configure Environment Variables**

In Vercel dashboard, add these environment variables:

```bash
# App Settings
APP_ENV=production
APP_TITLE=Flowndly
HOST=https://your-app.vercel.app
PROTOCOL=https
PORT=3000
TELEMETRY_ENABLED=false

# Security Keys (Generate new ones)
ENCRYPTION_KEY=your_encryption_key_here
WEBHOOK_SECRET_KEY=your_webhook_secret_here
APP_SECRET_KEY=your_app_secret_here

# External PostgreSQL (Supabase/PlanetScale)
POSTGRES_HOST=your-db-host.com
POSTGRES_PORT=5432
POSTGRES_DATABASE=flowndly_db
POSTGRES_USERNAME=your_db_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_ENABLE_SSL=true

# External Redis (Upstash/Redis Cloud)
REDIS_HOST=your-redis-host.com
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
REDIS_TLS=true

# File Storage (Optional)
STORAGE_PROVIDER=s3
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret
AWS_REGION=us-east-1
AWS_BUCKET_NAME=your-bucket
```

### **Step 5: Deploy to Vercel**

1. **Deploy from CLI**:
   ```bash
   vercel --prod
   ```

2. **Or deploy from GitHub**:
   - Connect your GitHub repository to Vercel
   - Vercel will auto-deploy on push

### **Step 6: Run Database Migrations**

After deployment, you need to run migrations:

1. **SSH into Vercel function** (if possible)
2. **Or use a migration script**:
   ```bash
   # Create a migration script
   vercel env pull .env
   node -e "
   require('dotenv').config();
   const knex = require('knex')(require('./packages/backend/knexfile.js').default);
   knex.migrate.latest().then(() => {
     console.log('Migrations completed');
     process.exit(0);
   }).catch(err => {
     console.error('Migration failed:', err);
     process.exit(1);
   });
   "
   ```

## 🔧 **Vercel-Specific Configuration**

### **Create a Vercel-specific package.json**:
```json
{
  "name": "flowndly-vercel",
  "version": "1.0.0",
  "main": "packages/backend/src/index.js",
  "scripts": {
    "start": "node packages/backend/src/index.js",
    "build": "echo 'No build step required'",
    "vercel-build": "echo 'Vercel build completed'"
  },
  "dependencies": {
    // Copy from packages/backend/package.json
  }
}
```

### **Modify the main entry point**:
```javascript
// packages/backend/src/index.js
const app = require('./app');

// Vercel serverless function export
module.exports = app;

// For local development
if (process.env.NODE_ENV !== 'production') {
  const port = process.env.PORT || 3000;
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}
```

## 🚨 **Common Vercel Issues & Solutions**

### **Issue 1: 404 Error**
**Cause**: Wrong entry point or routing configuration
**Solution**: 
- Check `vercel.json` configuration
- Ensure entry point path is correct
- Verify routes are properly configured

### **Issue 2: Database Connection Failed**
**Cause**: External database not configured
**Solution**:
- Set up Supabase/PlanetScale database
- Configure environment variables
- Check SSL settings

### **Issue 3: Redis Connection Failed**
**Cause**: External Redis not configured
**Solution**:
- Set up Upstash/Redis Cloud
- Configure environment variables
- Enable TLS for Redis

### **Issue 4: Function Timeout**
**Cause**: Vercel 30-second limit
**Solution**:
- Optimize database queries
- Use background jobs for long-running tasks
- Consider using Vercel Cron Jobs

## 💰 **Cost Comparison**

**Vercel + External Services**: $10-20/month
- ✅ Excellent performance
- ✅ Global CDN
- ✅ Easy deployment
- ❌ Requires external services
- ❌ More complex setup

**Railway**: $5-10/month
- ❌ SSL certificate issues
- ✅ All-in-one solution
- ❌ Complex configuration

**cPanel**: $5-15/month
- ✅ No SSL issues
- ✅ Easier configuration
- ✅ Better control

## 🎯 **Recommended External Services**

### **Database Options:**
1. **Supabase** - Free tier, PostgreSQL
2. **PlanetScale** - Free tier, MySQL
3. **Railway PostgreSQL** - Free tier
4. **Neon** - Free tier, PostgreSQL

### **Redis Options:**
1. **Upstash Redis** - Free tier
2. **Redis Cloud** - Free tier
3. **Railway Redis** - Free tier

## 📞 **Need Help?**

If you're getting 404 errors:
1. **Check your `vercel.json` configuration**
2. **Verify the entry point path**
3. **Check Vercel deployment logs**
4. **Ensure all environment variables are set**

**Vercel deployment requires external services but provides excellent performance and global CDN!**
