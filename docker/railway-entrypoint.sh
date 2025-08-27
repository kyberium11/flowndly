#!/bin/sh

set -e

echo "🚀 ========================================="
echo "🚀 Starting Railway entrypoint script..."
echo "🚀 ========================================="
echo "📅 Timestamp: $(date)"
echo "📁 Current directory: $(pwd)"
echo "👤 User: $(whoami)"
echo "🔧 Node version: $(node --version)"
echo "📦 Yarn version: $(yarn --version)"

echo ""
echo "🔍 ========================================="
echo "🔍 ENVIRONMENT VARIABLES ANALYSIS"
echo "🔍 ========================================="

# Check for critical environment variables
echo "🔍 Checking critical environment variables..."

# Database variables
if [ -n "$DATABASE_URL" ]; then
  echo "✅ DATABASE_URL: [SET] - Length: ${#DATABASE_URL} characters"
  echo "🔍 DATABASE_URL starts with: $(echo $DATABASE_URL | cut -c1-20)..."
else
  echo "❌ DATABASE_URL: [MISSING]"
fi

if [ -n "$POSTGRES_HOST" ]; then
  echo "✅ POSTGRES_HOST: $POSTGRES_HOST"
else
  echo "⚠️ POSTGRES_HOST: [NOT SET]"
fi

if [ -n "$POSTGRES_PORT" ]; then
  echo "✅ POSTGRES_PORT: $POSTGRES_PORT"
else
  echo "⚠️ POSTGRES_PORT: [NOT SET]"
fi

# Redis variables
if [ -n "$REDIS_URL" ]; then
  echo "✅ REDIS_URL: [SET] - Length: ${#REDIS_URL} characters"
  echo "🔍 REDIS_URL starts with: $(echo $REDIS_URL | cut -c1-20)..."
else
  echo "⚠️ REDIS_URL: [NOT SET]"
fi

if [ -n "$REDISHOST" ]; then
  echo "✅ REDISHOST: $REDISHOST"
else
  echo "⚠️ REDISHOST: [NOT SET]"
fi

if [ -n "$REDISPORT" ]; then
  echo "✅ REDISPORT: $REDISPORT"
else
  echo "⚠️ REDISPORT: [NOT SET]"
fi

# Security keys
if [ -n "$ENCRYPTION_KEY" ]; then
  echo "✅ ENCRYPTION_KEY: [SET] - Length: ${#ENCRYPTION_KEY} characters"
else
  echo "❌ ENCRYPTION_KEY: [MISSING]"
fi

if [ -n "$WEBHOOK_SECRET_KEY" ]; then
  echo "✅ WEBHOOK_SECRET_KEY: [SET] - Length: ${#WEBHOOK_SECRET_KEY} characters"
else
  echo "❌ WEBHOOK_SECRET_KEY: [MISSING]"
fi

if [ -n "$APP_SECRET_KEY" ]; then
  echo "✅ APP_SECRET_KEY: [SET] - Length: ${#APP_SECRET_KEY} characters"
else
  echo "⚠️ APP_SECRET_KEY: [NOT SET]"
fi

# App settings
if [ -n "$APP_ENV" ]; then
  echo "✅ APP_ENV: $APP_ENV"
else
  echo "⚠️ APP_ENV: [NOT SET]"
fi

if [ -n "$HOST" ]; then
  echo "✅ HOST: $HOST"
else
  echo "⚠️ HOST: [NOT SET]"
fi

if [ -n "$PORT" ]; then
  echo "✅ PORT: $PORT"
else
  echo "⚠️ PORT: [NOT SET]"
fi

# SSL configuration
if [ -n "$POSTGRES_ENABLE_SSL" ]; then
  echo "✅ POSTGRES_ENABLE_SSL: $POSTGRES_ENABLE_SSL"
else
  echo "⚠️ POSTGRES_ENABLE_SSL: [NOT SET]"
fi

echo ""
echo "🔍 ========================================="
echo "🔍 ALL ENVIRONMENT VARIABLES (filtered)"
echo "🔍 ========================================="
env | grep -E "(DATABASE_URL|REDIS_URL|POSTGRES_|REDIS_|APP_|WORKER|HOST|PORT|PROTOCOL)" | sort || echo "No relevant env vars found"

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

echo ""
echo "🔍 ========================================="
echo "🔍 VALIDATION CHECKS"
echo "🔍 ========================================="

# Check for required environment variables
if [ -z "$DATABASE_URL" ] && [ -z "$POSTGRES_HOST" ]; then
  echo "❌ ERROR: DATABASE_URL or POSTGRES_HOST is required!"
  echo "Please add DATABASE_URL to your Railway environment variables."
  echo "You can find this in your PostgreSQL service variables."
  exit 1
else
  echo "✅ Database connection variable found"
fi

if [ -z "$REDIS_URL" ] && [ -z "$REDIS_HOST" ] && [ -z "$REDISHOST" ]; then
  echo "❌ ERROR: REDIS_URL, REDIS_HOST, or REDISHOST is required!"
  echo "Please add Redis connection variables to your Railway environment variables."
  echo "You can find this in your Redis service variables."
  exit 1
else
  echo "✅ Redis connection variable found"
fi

if [ -z "$ENCRYPTION_KEY" ]; then
  echo "❌ ERROR: ENCRYPTION_KEY is required!"
  echo "Please add ENCRYPTION_KEY to your Railway environment variables."
  exit 1
else
  echo "✅ ENCRYPTION_KEY found"
fi

if [ -z "$WEBHOOK_SECRET_KEY" ]; then
  echo "❌ ERROR: WEBHOOK_SECRET_KEY is required!"
  echo "Please add WEBHOOK_SECRET_KEY to your Railway environment variables."
  exit 1
else
  echo "✅ WEBHOOK_SECRET_KEY found"
fi

echo ""
echo "🔍 ========================================="
echo "🔍 DATABASE CONFIGURATION"
echo "🔍 ========================================="

# Parse DATABASE_URL if provided by Railway
if [ -n "$DATABASE_URL" ]; then
  echo "🔍 Parsing DATABASE_URL: $DATABASE_URL"
  
  # Extract components from DATABASE_URL
  # Format: postgresql://username:password@host:port/database
  DB_HOST=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
  DB_PORT=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
  DB_NAME=$(echo $DATABASE_URL | sed -n 's/.*\///p' | sed 's/?.*//')
  DB_USER=$(echo $DATABASE_URL | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
  DB_PASS=$(echo $DATABASE_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p')
  
  # Ensure we're using Railway internal hostnames
  if [[ "$DB_HOST" == "localhost" || "$DB_HOST" == "127.0.0.1" ]]; then
    echo "⚠️ Detected localhost in DATABASE_URL, this might cause issues in Railway"
    echo "🔍 Original DB_HOST: $DB_HOST"
  fi
  
  echo "🔍 Extracted database components:"
  echo "   DB_HOST: $DB_HOST"
  echo "   DB_PORT: $DB_PORT"
  echo "   DB_NAME: $DB_NAME"
  echo "   DB_USER: $DB_USER"
  echo "   DB_PASS: [hidden]"
  
  # Set individual variables
  export POSTGRES_HOST=$DB_HOST
  export POSTGRES_PORT=$DB_PORT
  export POSTGRES_DATABASE=$DB_NAME
  export POSTGRES_USERNAME=$DB_USER
  export POSTGRES_PASSWORD=$DB_PASS
  
  # Modify DATABASE_URL to include SSL parameters for Railway
  echo "🔍 Modifying DATABASE_URL to include SSL parameters..."
  if [[ "$DATABASE_URL" == *"?"* ]]; then
    # URL already has parameters, add SSL parameter
    export DATABASE_URL="${DATABASE_URL}&sslmode=require&sslcert=&sslkey=&sslrootcert="
  else
    # URL has no parameters, add SSL parameters
    export DATABASE_URL="${DATABASE_URL}?sslmode=require&sslcert=&sslkey=&sslrootcert="
  fi
  echo "🔍 Modified DATABASE_URL: $DATABASE_URL"
  
  # Enable SSL with rejectUnauthorized: false for Railway (official solution)
  export POSTGRES_ENABLE_SSL=true
  echo "🔍 Enabled SSL with rejectUnauthorized: false for Railway (official solution)"
  echo "🔍 POSTGRES_ENABLE_SSL set to: $POSTGRES_ENABLE_SSL"
else
  echo "⚠️ No DATABASE_URL found, using individual POSTGRES_* variables"
  # Enable SSL for Railway
  export POSTGRES_ENABLE_SSL=true
fi

echo ""
echo "🔍 ========================================="
echo "🔍 AUTOMATIC RAILWAY SERVICE DETECTION"
echo "🔍 ========================================="

# Auto-detect Railway services and set connection variables
echo "🔍 Detecting Railway services..."

# Auto-set HOST if not provided
if [ -z "$HOST" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  export HOST=$RAILWAY_PUBLIC_DOMAIN
  echo "🔍 Auto-set HOST: $HOST"
fi

# Auto-detect Railway services and set connection variables
echo "🔍 Detecting Railway services..."

# Check for Railway service URLs
if [ -n "$RAILWAY_SERVICE_FLOWNDLY_DATABASE_URL" ]; then
  echo "✅ Found flowndly-database service"
  DB_SERVICE_HOST=$(echo $RAILWAY_SERVICE_FLOWNDLY_DATABASE_URL | sed 's/.*@//' | sed 's/:.*//')
  echo "🔍 Database host: $DB_SERVICE_HOST"
  
  # Set database connection variables
  if [ -z "$DATABASE_URL" ]; then
    export DATABASE_URL="postgresql://postgres:Jf}M#d5en@zz8a0hkaGZ)RN2U9(0$u]/@${DB_SERVICE_HOST}:5432/railway"
    echo "🔍 Auto-generated DATABASE_URL"
  fi
  
  if [ -z "$POSTGRES_HOST" ]; then
    export POSTGRES_HOST=$DB_SERVICE_HOST
    echo "🔍 Auto-set POSTGRES_HOST: $POSTGRES_HOST"
  fi
fi

if [ -n "$RAILWAY_SERVICE_FLOWNDLY_REDIS_URL" ]; then
  echo "✅ Found flowndly-redis service"
  REDIS_SERVICE_HOST=$(echo $RAILWAY_SERVICE_FLOWNDLY_REDIS_URL | sed 's/.*@//' | sed 's/:.*//')
  echo "🔍 Redis host: $REDIS_SERVICE_HOST"
  
  # Set Redis connection variables
  if [ -z "$REDIS_URL" ]; then
    export REDIS_URL="redis://default:)z(pul-j?w]rgrzA03r-gMcIx]GM1eB^@${REDIS_SERVICE_HOST}:6379"
    echo "🔍 Auto-generated REDIS_URL"
  fi
  
  if [ -z "$REDIS_HOST" ]; then
    export REDIS_HOST=$REDIS_SERVICE_HOST
    echo "🔍 Auto-set REDIS_HOST: $REDIS_HOST"
  fi
  
  if [ -z "$REDISHOST" ]; then
    export REDISHOST=$REDIS_SERVICE_HOST
    echo "🔍 Auto-set REDISHOST: $REDISHOST"
  fi
fi

echo ""
echo "🔍 ========================================="
echo "🔍 REDIS CONFIGURATION"
echo "🔍 ========================================="

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
    echo "🔍 REDIS_PASSWORD: [set]"
  fi
elif [ -n "$REDISHOST" ]; then
  echo "🔍 Using Railway Redis configuration:"
  echo "🔍 REDISHOST: $REDISHOST"
  
  export REDIS_HOST=$REDISHOST
  # Use default Redis port if not specified
  export REDIS_PORT=${REDISPORT:-6379}
  echo "🔍 REDIS_PORT: $REDIS_PORT"
  
  if [ -n "$REDIS_PASSWORD" ]; then
    echo "🔍 REDIS_PASSWORD: [set]"
    export REDIS_PASSWORD=$REDIS_PASSWORD
  else
    echo "🔍 REDIS_PASSWORD: [not set]"
  fi
else
  echo "⚠️ No Railway Redis configuration found, using defaults"
  echo "⚠️ This will likely cause connection issues in Railway!"
  export REDIS_HOST=127.0.0.1
  export REDIS_PORT=6379
fi

# Ensure we're using Railway internal hostnames for Redis
if [[ "$REDIS_HOST" == "localhost" || "$REDIS_HOST" == "127.0.0.1" ]]; then
  echo "⚠️ Detected localhost in Redis configuration, this will cause issues in Railway"
  echo "🔍 Original REDIS_HOST: $REDIS_HOST"
  echo "🔍 Please ensure REDISHOST is set to the Railway Redis service internal hostname"
fi

echo ""
echo "🔍 ========================================="
echo "🔍 FINAL CONFIGURATION SUMMARY"
echo "🔍 ========================================="
echo "🔍 Database Configuration:"
echo "   POSTGRES_HOST: $POSTGRES_HOST"
echo "   POSTGRES_PORT: $POSTGRES_PORT"
echo "   POSTGRES_DATABASE: $POSTGRES_DATABASE"
echo "   POSTGRES_USERNAME: $POSTGRES_USERNAME"
echo "   POSTGRES_PASSWORD: [hidden]"
echo "   POSTGRES_ENABLE_SSL: $POSTGRES_ENABLE_SSL"
echo "   DATABASE_URL: $DATABASE_URL"
echo ""
echo "🔍 Redis Configuration:"
echo "   REDIS_HOST: $REDIS_HOST"
echo "   REDIS_PORT: $REDIS_PORT"
echo "   REDIS_PASSWORD: [hidden]"
echo ""
echo "🔍 Application Configuration:"
echo "   APP_ENV: $APP_ENV"
echo "   HOST: $HOST"
echo "   PORT: $PORT"
echo "   PROTOCOL: $PROTOCOL"

echo ""
echo "🔍 ========================================="
echo "🔍 DIRECTORY STRUCTURE CHECK"
echo "🔍 ========================================="
echo "📁 Current directory contents:"
ls -la

echo ""
echo "📁 Checking for packages/backend directory:"
if [ -d "packages/backend" ]; then
  echo "✅ packages/backend directory exists"
  echo "📁 packages/backend contents:"
  ls -la packages/backend/
else
  echo "❌ packages/backend directory not found!"
  echo "📁 Available directories:"
  ls -la */
  exit 1
fi

cd packages/backend

echo ""
echo "🔍 ========================================="
echo "🔍 BACKEND DIRECTORY ANALYSIS"
echo "🔍 ========================================="
echo "📁 Changed to backend directory: $(pwd)"
echo "📁 Backend directory contents:"
ls -la

echo "📁 Checking for package.json:"
if [ -f "package.json" ]; then
  echo "✅ package.json found"
  echo "📦 Package name: $(node -p "require('./package.json').name")"
  echo "📦 Package version: $(node -p "require('./package.json').version")"
else
  echo "❌ package.json not found!"
  exit 1
fi

echo ""
echo "🔍 ========================================="
echo "🔍 NODE MODULES CHECK"
echo "🔍 =============h============================"
if [ -d "node_modules" ]; then
  echo "✅ node_modules directory exists"
  echo "📦 Number of packages: $(find node_modules -maxdepth 1 -type d | wc -l)"
else
  echo "⚠️ node_modules directory not found, installing dependencies..."
  yarn install
fi

echo ""
echo "🔧 ========================================="
echo "🔧 STARTING APPLICATION"
echo "🔧 ========================================="

if [ -n "$WORKER" ]; then
  echo "🔄 Starting worker process..."
  echo "🔍 WORKER environment variable: $WORKER"
  yarn start:worker
else
  echo "🗄️ Attempting database migrations..."
  echo "🔍 Migration command: yarn db:migrate"
  if yarn db:migrate; then
    echo "✅ Database migrations completed successfully"
  else
    echo "⚠️ Database migrations failed, but continuing..."
  fi
  
  echo "👤 Attempting to seed user..."
  echo "🔍 Seed command: yarn db:seed:user"
  if yarn db:seed:user; then
    echo "✅ User seeding completed successfully"
  else
    echo "⚠️ User seeding failed, but continuing..."
  fi
  
  echo "🚀 Starting main application..."
  echo "🔍 Start command: yarn start"
  exec yarn start
fi
