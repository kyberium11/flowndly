#!/bin/bash
# Flowndly cPanel Startup Script
# Place this in your cPanel home directory

echo "🚀 Starting Flowndly on cPanel..."
echo "📅 Timestamp: $(date)"
echo "📁 Current directory: $(pwd)"

# Set environment variables
export NODE_ENV=production
export APP_ENV=production
export PORT=3000

# Navigate to Flowndly directory
cd /home/$(whoami)/public_html/flowndly

echo "📁 Changed to Flowndly directory: $(pwd)"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install --production
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️ .env file not found. Please create one with your configuration."
    echo "📝 Example .env file:"
    cat << EOF
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

# Database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DATABASE=flowndly_db
POSTGRES_USERNAME=flowndly_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_ENABLE_SSL=false

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
EOF
    exit 1
fi

# Run database migrations
echo "🗄️ Running database migrations..."
npm run migrate

# Seed initial user
echo "👤 Seeding initial user..."
npm run seed:user

# Start the application
echo "🚀 Starting Flowndly application..."
npm start
