# 🚀 Flowndly cPanel Deployment Guide

## 📋 Prerequisites

- [ ] cPanel hosting with Node.js support
- [ ] PostgreSQL database (cPanel or external)
- [ ] Redis cache (cPanel or external)
- [ ] Domain name pointing to your hosting

## 🎯 Step-by-Step cPanel Deployment

### Step 1: Prepare Your Application

1. **Create a production build**:
   ```bash
   # In your local Flowndly directory
   cd automatisch/packages/backend
   yarn install --production
   ```

2. **Create a cPanel-specific package.json**:
   ```json
   {
     "name": "flowndly-cpanel",
     "version": "1.0.0",
     "main": "src/index.js",
     "scripts": {
       "start": "node src/index.js",
       "migrate": "knex migrate:latest",
       "seed": "knex seed:run"
     },
     "dependencies": {
       // Copy from packages/backend/package.json
     }
   }
   ```

### Step 2: Upload to cPanel

1. **Log into cPanel**
2. **Go to File Manager**
3. **Navigate to your domain's public_html or a subdirectory**
4. **Upload your Flowndly files**

### Step 3: Set Up Node.js in cPanel

1. **Find "Node.js" in cPanel**
2. **Create a new Node.js app**:
   - **Node.js version**: 18.x or 20.x
   - **Application mode**: Production
   - **Application root**: Your Flowndly directory
   - **Application URL**: Your domain
   - **Application startup file**: `src/index.js`

### Step 4: Configure Environment Variables

In cPanel Node.js settings, add these environment variables:

```bash
# App Settings
APP_ENV=production
APP_TITLE=Flowndly
HOST=yourdomain.com
PROTOCOL=https
PORT=3000
TELEMETRY_ENABLED=false

# Security Keys (Generate new ones)
ENCRYPTION_KEY=your_encryption_key_here
WEBHOOK_SECRET_KEY=your_webhook_secret_here
APP_SECRET_KEY=your_app_secret_here

# Database (cPanel PostgreSQL or external)
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DATABASE=flowndly_db
POSTGRES_USERNAME=flowndly_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_ENABLE_SSL=false

# Redis (cPanel Redis or external)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
```

### Step 5: Set Up Database

#### Option A: cPanel PostgreSQL
1. **Go to "PostgreSQL Databases" in cPanel**
2. **Create a new database**: `flowndly_db`
3. **Create a new user**: `flowndly_user`
4. **Add user to database** with all privileges
5. **Note the connection details**

#### Option B: External PostgreSQL
Use services like:
- **Railway PostgreSQL** (free tier)
- **Supabase** (free tier)
- **PlanetScale** (free tier)
- **Neon** (free tier)

### Step 6: Set Up Redis

#### Option A: cPanel Redis (if available)
1. **Check if Redis is available in cPanel**
2. **Create Redis instance**
3. **Note connection details**

#### Option B: External Redis
Use services like:
- **Redis Cloud** (free tier)
- **Upstash Redis** (free tier)
- **Railway Redis** (free tier)

### Step 7: Run Database Migrations

1. **SSH into your server** (if available)
2. **Navigate to your Flowndly directory**
3. **Run migrations**:
   ```bash
   cd /path/to/flowndly
   yarn migrate
   yarn seed
   ```

### Step 8: Configure Domain

1. **Set up domain/subdomain** in cPanel
2. **Point to your Node.js application**
3. **Configure SSL certificate** (Let's Encrypt)

## 🔧 **cPanel-Specific Configuration**

### **Create a cPanel startup script**:
```bash
#!/bin/bash
# cPanel startup script for Flowndly

cd /home/username/public_html/flowndly
export NODE_ENV=production
export PORT=3000

# Start the application
node src/index.js
```

### **Set up Cron Jobs** (for background tasks):
```bash
# Every 5 minutes - run background jobs
*/5 * * * * cd /home/username/public_html/flowndly && yarn worker
```

## 🚨 **Common cPanel Issues & Solutions**

### Issue 1: Node.js Not Available
**Solution**: Contact your hosting provider to enable Node.js support

### Issue 2: Port Conflicts
**Solution**: Use the port assigned by cPanel (usually 3000 or 8080)

### Issue 3: Database Connection Issues
**Solution**: 
- Check database credentials
- Ensure database server allows connections
- Use external database if cPanel PostgreSQL is limited

### Issue 4: File Permissions
**Solution**: Set proper permissions:
```bash
chmod 755 /path/to/flowndly
chmod 644 /path/to/flowndly/.env
```

## 💰 **Cost Comparison**

**cPanel Hosting**: $5-15/month
- ✅ No SSL certificate issues
- ✅ Easier configuration
- ✅ Better control
- ✅ More reliable

**Railway**: $5-10/month
- ❌ SSL certificate problems
- ❌ Complex configuration
- ❌ Service dependencies

## 🎯 **Recommended cPanel Providers**

1. **Hostinger** - Good Node.js support
2. **A2 Hosting** - Excellent performance
3. **InMotion Hosting** - Reliable Node.js
4. **Bluehost** - cPanel with Node.js
5. **HostGator** - Affordable option

## 📞 **Need Help?**

If you need assistance with cPanel deployment:
1. **Check your hosting provider's Node.js documentation**
2. **Contact your hosting provider's support**
3. **Use external database services** for easier setup

**cPanel deployment should be much easier than Railway and won't have the SSL certificate issues you're experiencing!**
