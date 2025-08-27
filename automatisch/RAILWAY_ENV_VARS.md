# 🚀 Railway Environment Variables for Flowndly

## ⚠️ CRITICAL: Add These Missing Variables

You need to add these environment variables to your Railway web service:

### **Security Keys (MISSING)**
```bash
ENCRYPTION_KEY="zApjqkQOcXdf1q2EaJroT48/hTu1ke9xZq1aHmKvJ3u3Ax4q"
WEBHOOK_SECRET_KEY="/MLtwr4VS2AxvHyFNHPdxb11gKZp4G9wKhwcICFWCQEeQbkQ"
```

### **Redis Configuration (MISSING)**
```bash
REDISPORT="6379"
```

### **SSL Configuration (UPDATED - Official Railway Solution)**
```bash
POSTGRES_ENABLE_SSL="true"
```

## 📋 **Complete Railway Environment Variables**

Add ALL of these to your Railway web service:

```bash
# Security Keys (CRITICAL)
ENCRYPTION_KEY="zApjqkQOcXdf1q2EaJroT48/hTu1ke9xZq1aHmKvJ3u3Ax4q"
WEBHOOK_SECRET_KEY="/MLtwr4VS2AxvHyFNHPdxb11gKZp4G9wKhwcICFWCQEeQbkQ"
APP_SECRET_KEY="OaZcbutL5UN5RoucF9+q6TYNX2HiKMP3Mzh3Hi/0ZDY+c3ch"

# App Settings
HOST="https://flowndly-main-production-4793.up.railway.app/"
PROTOCOL="https"
PORT="3000"
APP_ENV="production"
APP_TITLE="Flowndly"
TELEMETRY_ENABLED="false"

# Database (Railway auto-provides these)
DATABASE_URL="${{flowndly-database.DATABASE_URL}}"
POSTGRES_PASSWORD="${{flowndly-database.POSTGRES_PASSWORD}}"

# Database SSL Configuration (UPDATED)
POSTGRES_ENABLE_SSL="true"

# Redis (Railway auto-provides these)
REDISHOST="${{flowndly-redis.REDISHOST}}"
REDISPORT="6379"
```

## 🔧 **How to Add Variables in Railway**

1. **Go to your Railway project dashboard**
2. **Click on your web service**
3. **Go to "Variables" tab**
4. **Add each variable** from the list above
5. **Click "Deploy"** to apply changes

## ⚠️ **Important Notes**

- **POSTGRES_ENABLE_SSL="true"** - This enables SSL with `rejectUnauthorized: false` for Railway's self-signed certificates
- **ENCRYPTION_KEY** and **WEBHOOK_SECRET_KEY** are required for the app to start
- **REDISPORT** is needed for Redis connection
- All other variables should be auto-provided by Railway

## 🔒 **SSL Configuration (Official Railway Solution)**

Based on [Railway's official recommendation](https://station.railway.com/questions/failed-to-prune-sessions-error-self-si-76cc4c01), the application is now configured to:
- **Enable SSL** for secure connections
- **Use `rejectUnauthorized: false`** to accept Railway's self-signed certificates
- **Follow Railway's best practices** for PostgreSQL connections

**Railway Employee Response**: "Yes the Postgres databases Railway deploys use self-signed certificates, this is something your app will need to be able to support. The default way to do this is to use `ssl: { rejectUnauthorized: false }` with railway which I think is ok for now."

## 🎯 **After Adding Variables**

1. **Update your Railway environment variable**: Change `POSTGRES_ENABLE_SSL` to `"true"`
2. **Redeploy your application**
3. **The SSL certificate error should be resolved**
4. **Your Flowndly application should start successfully!**
