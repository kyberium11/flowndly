# 🔧 Railway Deployment Troubleshooting Guide

## 🚨 Current Issues

Based on your Railway dashboard:
- **`flowndly-main`**: Stuck in "Deploying (08:11)" state
- **`flowndly-worker`**: "Deploy failed (2 hours ago)"
- **`flowndly-database`** and **`flowndly-redis`**: Healthy ✅

## 🔍 Troubleshooting Steps

### Step 1: Check Deployment Logs

1. **Click on `flowndly-main`** service in Railway dashboard
2. **Go to "Logs" tab**
3. **Look for error messages**, especially:
   - SSL certificate errors
   - Missing environment variables
   - Database connection failures

### Step 2: Verify Environment Variables

Make sure these are set in your `flowndly-main` service:

```bash
# CRITICAL - Security Keys
ENCRYPTION_KEY="zApjqkQOcXdf1q2EaJroT48/hTu1ke9xZq1aHmKvJ3u3Ax4q"
WEBHOOK_SECRET_KEY="/MLtwr4VS2AxvHyFNHPdxb11gKZp4G9wKhwcICFWCQEeQbkQ"
APP_SECRET_KEY="OaZcbutL5UN5RoucF9+q6TYNX2HiKMP3Mzh3Hi/0ZDY+c3ch"

# CRITICAL - SSL Configuration
POSTGRES_ENABLE_SSL="false"

# App Settings
HOST="https://flowndly-main-production-4793.up.railway.app/"
PROTOCOL="https"
PORT="3000"
APP_ENV="production"
APP_TITLE="Flowndly"
TELEMETRY_ENABLED="false"

# Database (Railway auto-provides)
DATABASE_URL="${{flowndly-database.DATABASE_URL}}"
POSTGRES_PASSWORD="${{flowndly-database.POSTGRES_PASSWORD}}"

# Redis (Railway auto-provides)
REDISHOST="${{flowndly-redis.REDISHOST}}"
REDISPORT="6379"
```

### Step 3: Force Redeploy

If the deployment is stuck:

1. **Go to `flowndly-main` service**
2. **Click "Deployments" tab**
3. **Click "Deploy" button** to force a new deployment
4. **Or click the three dots** → "Redeploy"

### Step 4: Check Service Dependencies

Make sure the services are properly connected:

1. **Verify `flowndly-main` connects to:**
   - `flowndly-database`
   - `flowndly-redis`

2. **Check that the connection arrows** are showing in the Architecture view

## 🚨 Common Issues & Solutions

### Issue 1: SSL Certificate Error
**Error**: `self-signed certificate in certificate chain`

**Solution**: 
- Set `POSTGRES_ENABLE_SSL="false"` in environment variables
- This has been configured in the code

### Issue 2: Missing Environment Variables
**Error**: `ENCRYPTION_KEY is required` or `WEBHOOK_SECRET_KEY is required`

**Solution**:
- Add the missing security keys to your environment variables

### Issue 3: Database Connection Failed
**Error**: `ECONNREFUSED` or connection timeout

**Solution**:
- Verify `DATABASE_URL` is set correctly
- Check that `flowndly-database` service is healthy
- Ensure the service names match in the variable substitution

### Issue 4: Redis Connection Failed
**Error**: Redis connection refused

**Solution**:
- Verify `REDISHOST` is set correctly
- Check that `flowndly-redis` service is healthy
- Ensure `REDISPORT="6379"` is set

## 🔄 Quick Fix Steps

1. **Check the logs** for `flowndly-main` service
2. **Verify all environment variables** are set correctly
3. **Force redeploy** the `flowndly-main` service
4. **Wait 2-3 minutes** for deployment to complete
5. **Check logs again** for any new errors

## 📞 Need Help?

If the issue persists:
1. **Share the deployment logs** from `flowndly-main`
2. **Screenshot of environment variables** (hide sensitive values)
3. **Any error messages** you see in the Railway dashboard
