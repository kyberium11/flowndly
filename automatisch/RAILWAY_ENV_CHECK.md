# Railway Environment Variables Check

## 🚨 **Current Issues:**
- Database connecting to `localhost:5432` instead of Railway internal hostname
- Redis connecting to `127.0.0.1:6379` instead of Railway internal hostname
- Database service still deploying

## 🔧 **Required Environment Variables for `flowndly-main`:**

### **Database Variables:**
```
DATABASE_URL=${{flowndly-database.DATABASE_URL}}
POSTGRES_HOST=${{flowndly-database.PGHOST}}
POSTGRES_PORT=${{flowndly-database.PGPORT}}
POSTGRES_DATABASE=${{flowndly-database.PGDATABASE}}
POSTGRES_USERNAME=${{flowndly-database.PGUSER}}
POSTGRES_PASSWORD=${{flowndly-database.PGPASSWORD}}
POSTGRES_ENABLE_SSL=true
```

### **Redis Variables:**
```
REDISHOST=${{flowndly-redis.REDISHOST}}
REDISPORT=${{flowndly-redis.REDISPORT}}
REDIS_PASSWORD=${{flowndly-redis.REDIS_PASSWORD}}
```

### **Security Keys:**
```
ENCRYPTION_KEY=your_encryption_key_here
WEBHOOK_SECRET_KEY=your_webhook_secret_here
APP_SECRET_KEY=your_app_secret_here
```

### **App Configuration:**
```
APP_ENV=production
APP_TITLE=Flowndly
HOST=https://flowndly-main-production-4793.up.railway.app/
PROTOCOL=https
PORT=3000
TELEMETRY_ENABLED=false
```

## 📋 **Steps to Fix:**

1. **Wait for Database**: Ensure `flowndly-database` is fully deployed (green checkmark)

2. **Check Environment Variables**: Go to `flowndly-main` service → Variables tab

3. **Add Missing Variables**: Copy the variables above and add them to `flowndly-main`

4. **Redeploy**: Trigger a new deployment after adding variables

## 🔍 **How to Check Variables:**

1. Go to Railway dashboard
2. Select `flowndly-main` service
3. Click "Variables" tab
4. Verify all required variables are present
5. Check that Railway variable substitution is working (should show actual values, not `${{...}}`)

## ⚠️ **Important Notes:**

- **Database must be fully deployed** before main app can connect
- **Use Railway variable substitution** (`${{service.VARIABLE}}`) to connect to other services
- **Don't use localhost** - Railway services must use internal hostnames
- **SSL is required** for Railway PostgreSQL connections
