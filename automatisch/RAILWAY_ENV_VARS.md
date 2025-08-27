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

### **SSL Configuration (CRITICAL)**
```bash
POSTGRES_ENABLE_SSL="false"
```

## 📋 **Complete Railway Environment Variables**

Add ALL of these to your Railway web service:

```bash
# Security Keys (CRITICAL)
ENCRYPTION_KEY="Zemt0cQOioKXWJxhBjvNI8Govj3YQHfU0uWHjsoo6M/9OInm"
WEBHOOK_SECRET_KEY="OoQz2nrNEyOXlj6AOOgbloOzL/ESKpjZ0c7yzbKEQdIod7Yp"
APP_SECRET_KEY="PAVFqizT4yj1nLduqwnCiiIrDnsqSIEM8rPhwXsGX1i8nLba"

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

- **POSTGRES_ENABLE_SSL="false"** - This completely disables SSL for Railway internal connections to fix the certificate error
- **ENCRYPTION_KEY** and **WEBHOOK_SECRET_KEY** are required for the app to start
- **REDISPORT** is needed for Redis connection
- All other variables should be auto-provided by Railway

## 🔒 **SSL Configuration**

Due to persistent SSL certificate issues with Railway's internal connections, the application is now configured to:
- **Completely disable SSL** for Railway internal database connections
- **Bypass certificate validation** to resolve the self-signed certificate error
- **Maintain functionality** while working with Railway's infrastructure

## 🎯 **After Adding Variables**

1. **Redeploy your application**
2. **Check the logs** - SSL errors should be resolved
3. **Your Flowndly application should start successfully!**
