#!/bin/sh

set -e

echo "🚀 Starting Railway entrypoint script..."
echo "Current directory: $(pwd)"
echo "Available environment variables:"
env | grep -E "(DATABASE_URL|REDIS_URL|POSTGRES_|REDIS_|APP_|WORKER)" || echo "No relevant env vars found"

# Function to resolve Railway variable substitution
resolve_railway_var() {
    local var_value="$1"
    if [[ "$var_value" == *"\${{"* ]]; then
        # Extract the actual variable name from Railway substitution
        local actual_var=$(echo "$var_value" | sed 's/\${{[^}]*\.//' | sed 's/}}//')
        echo "$actual_var"
    else
        echo "$var_value"
    fi
}

# Check for required environment variables
if [ -z "$DATABASE_URL" ] && [ -z "$POSTGRES_HOST" ]; then
  echo "❌ ERROR: DATABASE_URL or POSTGRES_HOST is required!"
  echo "Please add DATABASE_URL to your Railway environment variables."
  echo "You can find this in your PostgreSQL service variables."
  exit 1
fi

if [ -z "$REDIS_URL" ] && [ -z "$REDIS_HOST" ] && [ -z "$REDISHOST" ]; then
  echo "❌ ERROR: REDIS_URL, REDIS_HOST, or REDISHOST is required!"
  echo "Please add Redis connection variables to your Railway environment variables."
  echo "You can find this in your Redis service variables."
  exit 1
fi

if [ -z "$ENCRYPTION_KEY" ]; then
  echo "❌ ERROR: ENCRYPTION_KEY is required!"
  echo "Please add ENCRYPTION_KEY to your Railway environment variables."
  exit 1
fi

if [ -z "$WEBHOOK_SECRET_KEY" ]; then
  echo "❌ ERROR: WEBHOOK_SECRET_KEY is required!"
  echo "Please add WEBHOOK_SECRET_KEY to your Railway environment variables."
  exit 1
fi

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
  # Explicitly disable SSL for Railway internal connections
  export POSTGRES_ENABLE_SSL=false
  echo "🔍 Disabled SSL for Railway internal database connection"
  echo "🔍 POSTGRES_ENABLE_SSL set to: $POSTGRES_ENABLE_SSL"
else
  echo "⚠️ No DATABASE_URL found, using individual POSTGRES_* variables"
  # Still disable SSL for Railway
  export POSTGRES_ENABLE_SSL=false
fi

# Set Redis configuration
if [ -n "$REDIS_URL" ]; then
  echo "🔍 Parsing REDIS_URL: $REDIS_URL"
  # Extract Redis components
  REDIS_HOST=$(echo $REDIS_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
  REDIS_PORT=$(echo $REDIS_URL | sed -n 's/.*:\([0-9]*\)$/\1/p')
  REDIS_PASSWORD=$(echo $REDIS_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')
  
  export REDIS_HOST=$REDIS_HOST
  export REDIS_PORT=$REDIS_PORT
  if [ -n "$REDIS_PASSWORD" ]; then
    export REDIS_PASSWORD=$REDIS_PASSWORD
  fi
elif [ -n "$REDISHOST" ]; then
  echo "🔍 Using Railway Redis configuration:"
  echo "🔍 REDISHOST: $REDISHOST"
  
  export REDIS_HOST=$REDISHOST
  # Use default Redis port if not specified
  export REDIS_PORT=${REDISPORT:-6379}
  echo "🔍 REDIS_PORT: $REDIS_PORT"
  
  if [ -n "$REDIS_PASSWORD" ]; then
    echo "🔍 REDIS_PASSWORD: [hidden]"
    export REDIS_PASSWORD=$REDIS_PASSWORD
  fi
else
  echo "⚠️ No Railway Redis configuration found, using defaults"
  export REDIS_HOST=127.0.0.1
  export REDIS_PORT=6379
fi

echo "🔍 Final configuration:"
echo "🔍 POSTGRES_HOST: $POSTGRES_HOST"
echo "🔍 POSTGRES_PORT: $POSTGRES_PORT"
echo "🔍 POSTGRES_DATABASE: $POSTGRES_DATABASE"
echo "🔍 POSTGRES_ENABLE_SSL: $POSTGRES_ENABLE_SSL"
echo "🔍 REDIS_HOST: $REDIS_HOST"
echo "🔍 REDIS_PORT: $REDIS_PORT"

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
