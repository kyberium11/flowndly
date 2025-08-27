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

### **SSL Configuration (MISSING)**
```bash
POSTGRES_ENABLE_SSL="false"
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

# Database SSL Configuration (CRITICAL)
POSTGRES_ENABLE_SSL="false"

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

- **POSTGRES_ENABLE_SSL="false"** is critical to fix the SSL certificate error
- **ENCRYPTION_KEY** and **WEBHOOK_SECRET_KEY** are required for the app to start
- **REDISPORT** is needed for Redis connection
- All other variables should be auto-provided by Railway

## 🎯 **After Adding Variables**

1. **Redeploy your application**
2. **Check the logs** - SSL errors should be resolved
3. **Your Flowndly application should start successfully!**
