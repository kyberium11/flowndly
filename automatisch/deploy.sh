#!/bin/bash

# 🚀 Flowndly Deployment Script
# This script helps you deploy Flowndly to production

set -e

echo "🚀 Flowndly Deployment Script"
echo "=============================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    
    # Generate secure keys
    ENCRYPTION_KEY=$(openssl rand -base64 36)
    WEBHOOK_SECRET_KEY=$(openssl rand -base64 36)
    APP_SECRET_KEY=$(openssl rand -base64 36)
    POSTGRES_PASSWORD=$(openssl rand -base64 32)
    
    # Create .env file
    cat > .env << EOF
# Flowndly Production Environment Variables
# Generated on $(date)

# Required Security Keys
ENCRYPTION_KEY=$ENCRYPTION_KEY
WEBHOOK_SECRET_KEY=$WEBHOOK_SECRET_KEY
APP_SECRET_KEY=$APP_SECRET_KEY
POSTGRES_PASSWORD=$POSTGRES_PASSWORD

# Application Settings
HOST=localhost
PROTOCOL=https
APP_ENV=production
APP_TITLE=Flowndly
TELEMETRY_ENABLED=false

# Database Settings
POSTGRES_DATABASE=automatisch
POSTGRES_USERNAME=automatisch_user
POSTGRES_ENABLE_SSL=false

# Logging
LOG_LEVEL=info

# ⚠️  IMPORTANT: Update HOST with your actual domain before deployment
# ⚠️  IMPORTANT: Change default passwords after first login
EOF
    
    echo "✅ .env file created with secure keys"
    echo "⚠️  Please update HOST with your actual domain name"
else
    echo "✅ .env file already exists"
fi

# Check if production compose exists
if [ ! -f docker-compose.production.yml ]; then
    echo "❌ docker-compose.production.yml not found"
    echo "Please ensure you have the production configuration file"
    exit 1
fi

# Copy production compose
echo "📋 Setting up production configuration..."
cp docker-compose.production.yml docker-compose.yml

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed"
    echo "Please install Docker Compose first: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Deploy
echo "🚀 Starting Flowndly deployment..."
echo "This may take a few minutes..."

docker compose down 2>/dev/null || true
docker compose up -d --build

echo ""
echo "🎉 Deployment completed!"
echo "=============================="
echo "🌐 Your Flowndly instance should be available at:"
echo "   http://localhost:3000 (or your configured domain)"
echo ""
echo "🔐 Default login credentials:"
echo "   Email: user@automatisch.io"
echo "   Password: sample"
echo ""
echo "⚠️  IMPORTANT SECURITY STEPS:"
echo "   1. Change the default password immediately"
echo "   2. Update HOST in .env with your actual domain"
echo "   3. Set up HTTPS/SSL for production"
echo ""
echo "📊 Check status: docker compose ps"
echo "📋 View logs: docker compose logs -f"
echo "🛑 Stop services: docker compose down"
