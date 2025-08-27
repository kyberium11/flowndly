#!/bin/sh

set -e

echo "🚀 Starting Railway entrypoint script..."
echo "Current directory: $(pwd)"
echo "Available environment variables:"
env | grep -E "(DATABASE_URL|REDIS_URL|POSTGRES_|REDIS_|APP_|WORKER)" || echo "No relevant env vars found"

# Parse DATABASE_URL if provided by Railway
if [ -n "$DATABASE_URL" ]; then
  echo "🔍 Parsing DATABASE_URL: $DATABASE_URL"
  # Extract components from DATABASE_URL
  # Format: postgresql://username:password@host:port/database
  DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
  DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
  DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\///p')
  DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
  DB_PASS=$(echo $DATABASE_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')
  
  echo "🔍 Extracted DB_HOST: $DB_HOST"
  echo "🔍 Extracted DB_PORT: $DB_PORT"
  echo "🔍 Extracted DB_NAME: $DB_NAME"
  echo "🔍 Extracted DB_USER: $DB_USER"
  
  # Set individual variables
  export POSTGRES_HOST=$DB_HOST
  export POSTGRES_PORT=$DB_PORT
  export POSTGRES_DATABASE=$DB_NAME
  export POSTGRES_USERNAME=$DB_USER
  export POSTGRES_PASSWORD=$DB_PASS
  export POSTGRES_ENABLE_SSL=true
else
  echo "⚠️ No DATABASE_URL found!"
fi

# Set Redis configuration
# Use the Railway-provided Redis variables
if [ -n "$REDISHOST" ] && [ -n "$REDISPORT" ]; then
  echo "🔍 Using Railway Redis configuration:"
  echo "🔍 REDISHOST: $REDISHOST"
  echo "🔍 REDISPORT: $REDISPORT"
  
  # Try multiple hostname formats for Railway internal networking
  if [ "$REDISHOST" = "flowndly-redis.railway.internal" ]; then
    echo "⚠️ Detected internal Railway hostname, trying multiple alternatives..."
    
    # Try different hostname formats
    echo "🔍 Testing hostname resolution..."
    
    # Option 1: Service name only (internal communication)
    if nslookup flowndly-redis >/dev/null 2>&1; then
      export REDIS_HOST="flowndly-redis"
      echo "✅ Using REDIS_HOST: flowndly-redis (internal service)"
    # Option 2: Use the original internal hostname
    elif nslookup flowndly-redis.railway.internal >/dev/null 2>&1; then
      export REDIS_HOST="flowndly-redis.railway.internal"
      echo "✅ Using REDIS_HOST: flowndly-redis.railway.internal (internal)"
    # Option 3: Try with .railway.app (external, should be last resort)
    elif nslookup flowndly-redis.railway.app >/dev/null 2>&1; then
      export REDIS_HOST="flowndly-redis.railway.app"
      echo "⚠️ Using REDIS_HOST: flowndly-redis.railway.app (external fallback)"
    # Option 4: Use service name anyway (Railway internal networking)
    else
      export REDIS_HOST="flowndly-redis"
      echo "⚠️ Using REDIS_HOST: flowndly-redis (service name fallback)"
    fi
  else
    export REDIS_HOST=$REDISHOST
    echo "🔍 Using provided REDIS_HOST: $REDIS_HOST"
  fi
  
  export REDIS_PORT=$REDISPORT
  if [ -n "$REDIS_PASSWORD" ]; then
    echo "🔍 REDIS_PASSWORD: [hidden]"
    export REDIS_PASSWORD=$REDIS_PASSWORD
  fi
  
  echo "🔍 Final Redis configuration:"
  echo "🔍 REDIS_HOST: $REDIS_HOST"
  echo "🔍 REDIS_PORT: $REDIS_PORT"
  echo "🔍 REDIS_PASSWORD: [set]"
  
  # Test the connection
  echo "🔍 Testing Redis connection..."
  if command -v redis-cli >/dev/null 2>&1; then
    if redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" ping >/dev/null 2>&1; then
      echo "✅ Redis connection successful!"
    else
      echo "⚠️ Redis connection test failed, but continuing..."
    fi
  else
    echo "⚠️ redis-cli not available, skipping connection test"
  fi
else
  echo "⚠️ No Railway Redis configuration found, using defaults"
  export REDIS_HOST=127.0.0.1
  export REDIS_PORT=6379
fi

cd packages/backend

echo "📁 Changed to backend directory: $(pwd)"
echo "🔧 Starting application..."

if [ -n "$WORKER" ]; then
  echo "🔄 Starting worker..."
  yarn start:worker
else
  echo "🗄️ Running database migrations..."
  yarn db:migrate
  echo "👤 Seeding user..."
  yarn db:seed:user
  echo "🚀 Starting main application..."
  yarn start
fi
