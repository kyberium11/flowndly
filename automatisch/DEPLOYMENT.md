# 🚀 Flowndly Deployment Guide

## 📋 Prerequisites

Before deploying, ensure you have:
- [ ] Git repository with your Flowndly code
- [ ] Generated secure environment variables
- [ ] Domain name (optional but recommended)

## 🔐 Environment Variables Setup

### Generate Required Secrets

```bash
# Generate encryption keys (run these commands)
ENCRYPTION_KEY=$(openssl rand -base64 36)
WEBHOOK_SECRET_KEY=$(openssl rand -base64 36)
APP_SECRET_KEY=$(openssl rand -base64 36)
POSTGRES_PASSWORD=$(openssl rand -base64 32)

# Save them securely
echo "ENCRYPTION_KEY=$ENCRYPTION_KEY" >> .env
echo "WEBHOOK_SECRET_KEY=$WEBHOOK_SECRET_KEY" >> .env
echo "APP_SECRET_KEY=$APP_SECRET_KEY" >> .env
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> .env
```

### Required Environment Variables

```bash
# Required
ENCRYPTION_KEY=your_generated_encryption_key
WEBHOOK_SECRET_KEY=your_generated_webhook_secret
APP_SECRET_KEY=your_generated_app_secret
POSTGRES_PASSWORD=your_generated_postgres_password

# Optional (with defaults)
HOST=your-domain.com
PROTOCOL=https
POSTGRES_DATABASE=automatisch
POSTGRES_USERNAME=automatisch_user
POSTGRES_ENABLE_SSL=false
LOG_LEVEL=info
```

## 🎯 Deployment Options

### Option 1: Render (Recommended)

1. **Fork the repository** to your GitHub account
2. **Modify `render.yaml`** for your custom settings
3. **Click "Deploy to Render"** button
4. **Set environment variables** in Render dashboard
5. **Deploy!**

**Advantages:**
- ✅ One-click deployment
- ✅ Managed PostgreSQL & Redis
- ✅ Free tier available
- ✅ Automatic HTTPS

### Option 2: Railway

1. **Connect your GitHub repository**
2. **Select Docker deployment**
3. **Set environment variables**
4. **Deploy**

**Advantages:**
- ✅ Simple setup
- ✅ Managed databases
- ✅ Good free tier

### Option 3: DigitalOcean App Platform

1. **Create new app**
2. **Connect GitHub repository**
3. **Select Docker deployment**
4. **Configure environment variables**
5. **Deploy**

**Advantages:**
- ✅ Docker-native
- ✅ Global CDN
- ✅ Predictable pricing

### Option 4: VPS with Docker

1. **Set up VPS** (Ubuntu 20.04+)
2. **Install Docker & Docker Compose**
3. **Clone repository**
4. **Set up environment variables**
5. **Run with production compose**

```bash
# On your VPS
git clone your-repo
cd automatisch
cp docker-compose.production.yml docker-compose.yml
# Edit .env with your variables
docker compose up -d
```

## 🔧 Production Configuration

### Using Production Docker Compose

```bash
# Use the production configuration
cp docker-compose.production.yml docker-compose.yml

# Set up environment variables
cp .env.example .env
# Edit .env with your values

# Deploy
docker compose up -d
```

### SSL/HTTPS Setup

For production, you should enable HTTPS:

1. **Use a reverse proxy** (nginx/traefik)
2. **Set up Let's Encrypt** for free SSL
3. **Configure `PROTOCOL=https`**

### Database Considerations

**For production, consider:**
- ✅ **Managed PostgreSQL** (Render, Railway, DO)
- ✅ **Database backups**
- ✅ **Connection pooling**
- ✅ **SSL connections**

## 📊 Monitoring & Maintenance

### Health Checks

The production setup includes health checks:
- **Main app**: `http://your-domain/health`
- **Database**: Automatic PostgreSQL health checks
- **Redis**: Automatic Redis health checks

### Logs

```bash
# View logs
docker compose logs -f main
docker compose logs -f worker

# View specific service
docker compose logs -f postgres
```

### Updates

```bash
# Update to latest version
git pull origin main
docker compose down
docker compose up -d --build
```

## 🛡️ Security Checklist

- [ ] **Strong passwords** for all services
- [ ] **HTTPS enabled**
- [ ] **Environment variables** properly set
- [ ] **Firewall configured**
- [ ] **Regular backups**
- [ ] **Monitoring enabled**

## 🆘 Troubleshooting

### Common Issues

1. **Database connection errors**
   - Check `POSTGRES_HOST` and credentials
   - Verify database is running

2. **Webhook URL issues**
   - Ensure `HOST` and `PROTOCOL` are correct
   - Check webhook endpoints are accessible

3. **Memory issues**
   - Increase container memory limits
   - Optimize Redis configuration

### Support

- Check the Flowndly documentation in this repository
- Review [GitHub issues](https://github.com/kyberium11/flowndly/issues)
- Join the [Discord community](https://discord.gg/dJSah9CVrC)

## 🎉 Success!

Once deployed, your Flowndly instance will be available at:
- **Web Interface**: `https://your-domain.com`
- **API**: `https://your-domain.com/api`
- **Webhooks**: `https://your-domain.com/webhooks`

**Default login**: `user@automatisch.io` / `sample`
**Remember to change the default password!**
