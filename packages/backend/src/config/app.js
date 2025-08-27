import { URL } from 'node:url';
import * as dotenv from 'dotenv';
import path from 'path';
import process from 'node:process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

console.log('🔍 =========================================');
console.log('🔍 LOADING APP CONFIGURATION');
console.log('🔍 =========================================');
console.log('🔍 APP_ENV:', process.env.APP_ENV);
console.log('🔍 Current working directory:', process.cwd());

if (process.env.APP_ENV === 'test') {
  console.log('🔍 Loading test environment from .env.test');
  dotenv.config({ path: path.resolve(__dirname, '../../.env.test') });
} else {
  console.log('🔍 Loading environment from .env file');
  dotenv.config();
}

const host = process.env.HOST || 'localhost';
const protocol = process.env.PROTOCOL || 'http';
const port = process.env.PORT || '3000';
const serveWebAppSeparately =
  process.env.SERVE_WEB_APP_SEPARATELY === 'true' ? true : false;

let apiUrl = new URL(
  process.env.API_URL || `${protocol}://${host}:${port}`
).toString();
apiUrl = apiUrl.substring(0, apiUrl.length - 1);

// use apiUrl by default, which has less priority over the following cases
let webAppUrl = apiUrl;

if (process.env.WEB_APP_URL) {
  // use env. var. if provided
  webAppUrl = new URL(process.env.WEB_APP_URL).toString();
  webAppUrl = webAppUrl.substring(0, webAppUrl.length - 1);
} else if (serveWebAppSeparately) {
  // no env. var. and serving separately, sign of development
  webAppUrl = 'http://localhost:3001';
}

let webhookUrl = new URL(process.env.WEBHOOK_URL || apiUrl).toString();
webhookUrl = webhookUrl.substring(0, webhookUrl.length - 1);

const publicDocsUrl = 'https://automatisch.io/docs';
const docsUrl = process.env.DOCS_URL || publicDocsUrl;

const appEnv = process.env.APP_ENV || 'development';

const appConfig = {
  host,
  protocol,
  port,
  appEnv: appEnv,
  logLevel: process.env.LOG_LEVEL || 'info',
  isDev: appEnv === 'development',
  isTest: appEnv === 'test',
  isProd: appEnv === 'production',
  version: '0.15.0',
  postgresDatabase: process.env.POSTGRES_DATABASE || 'automatisch_development',
  postgresSchema: process.env.POSTGRES_SCHEMA || 'public',
  postgresPort: parseInt(process.env.POSTGRES_PORT || '5432'),
  postgresHost: process.env.POSTGRES_HOST || 'localhost',
  postgresUsername:
    process.env.POSTGRES_USERNAME || 'automatisch_development_user',
  postgresPassword: process.env.POSTGRES_PASSWORD,
  postgresEnableSsl: process.env.POSTGRES_ENABLE_SSL === 'true',
  encryptionKey: process.env.ENCRYPTION_KEY || '',
  webhookSecretKey: process.env.WEBHOOK_SECRET_KEY || '',
  appSecretKey: process.env.APP_SECRET_KEY || '',
  serveWebAppSeparately,
  redisHost: process.env.REDIS_HOST || '127.0.0.1',
  redisName: process.env.REDIS_NAME || 'mymaster',
  redisPort: parseInt(process.env.REDIS_PORT || '6379'),
  redisUsername: process.env.REDIS_USERNAME,
  redisPassword: process.env.REDIS_PASSWORD,
  redisDb: parseInt(process.env.REDIS_DB || '0'),
  redisRole: process.env.REDIS_ROLE || 'master',
  redisTls: process.env.REDIS_TLS === 'true',
  redisSentinelHost: process.env.REDIS_SENTINEL_HOST,
  redisSentinelUsername: process.env.REDIS_SENTINEL_USERNAME,
  redisSentinelPassword: process.env.REDIS_SENTINEL_PASSWORD,
  redisSentinelPort: parseInt(process.env.REDIS_SENTINEL_PORT || '26379'),
  enableBullMQDashboard: process.env.ENABLE_BULLMQ_DASHBOARD === 'true',
  bullMQDashboardUsername: process.env.BULLMQ_DASHBOARD_USERNAME,
  bullMQDashboardPassword: process.env.BULLMQ_DASHBOARD_PASSWORD,
  baseUrl: apiUrl,
  webAppUrl,
  webhookUrl,
  docsUrl,
  telemetryEnabled: process.env.TELEMETRY_ENABLED === 'false' ? false : true,
  requestBodySizeLimit: '1mb',
  smtpHost: process.env.SMTP_HOST,
  smtpPort: parseInt(process.env.SMTP_PORT || '587'),
  smtpSecure: process.env.SMTP_SECURE === 'true',
  smtpUser: process.env.SMTP_USER,
  smtpPassword: process.env.SMTP_PASSWORD,
  fromEmail: process.env.FROM_EMAIL,
  isCloud: process.env.AUTOMATISCH_CLOUD === 'true',
  isSelfHosted: process.env.AUTOMATISCH_CLOUD !== 'true',
  isMation: process.env.MATION === 'true',
  paddleVendorId: Number(process.env.PADDLE_VENDOR_ID),
  paddleVendorAuthCode: process.env.PADDLE_VENDOR_AUTH_CODE,
  paddlePublicKey: process.env.PADDLE_PUBLIC_KEY,
  licenseKey: process.env.LICENSE_KEY,
  sentryDsn: process.env.SENTRY_DSN,
  CI: process.env.CI === 'true',
  disableNotificationsPage: process.env.DISABLE_NOTIFICATIONS_PAGE === 'true',
  disableFavicon: process.env.DISABLE_FAVICON === 'true',
  additionalDrawerLink: process.env.ADDITIONAL_DRAWER_LINK,
  additionalDrawerLinkIcon: process.env.ADDITIONAL_DRAWER_LINK_ICON,
  additionalDrawerLinkText: process.env.ADDITIONAL_DRAWER_LINK_TEXT,
  disableSeedUser: process.env.DISABLE_SEED_USER === 'true',
  httpProxy: process.env.http_proxy,
  httpsProxy: process.env.https_proxy,
  noProxy: process.env.no_proxy,
};

console.log('🔍 =========================================');
console.log('🔍 APP CONFIGURATION SUMMARY');
console.log('🔍 =========================================');
console.log('🔍 Environment:', appConfig.appEnv);
console.log('🔍 Host:', appConfig.host);
console.log('🔍 Protocol:', appConfig.protocol);
console.log('🔍 Port:', appConfig.port);
console.log('🔍 Base URL:', appConfig.baseUrl);
console.log('🔍 Web App URL:', appConfig.webAppUrl);
console.log('🔍 Webhook URL:', appConfig.webhookUrl);
console.log('🔍 Log Level:', appConfig.logLevel);
console.log('🔍 Is Development:', appConfig.isDev);
console.log('🔍 Is Production:', appConfig.isProd);
console.log('🔍 Is Test:', appConfig.isTest);

console.log('🔍 =========================================');
console.log('🔍 DATABASE CONFIGURATION');
console.log('🔍 =========================================');
console.log('🔍 PostgreSQL Host:', appConfig.postgresHost);
console.log('🔍 PostgreSQL Port:', appConfig.postgresPort);
console.log('🔍 PostgreSQL Database:', appConfig.postgresDatabase);
console.log('🔍 PostgreSQL Username:', appConfig.postgresUsername);
console.log('🔍 PostgreSQL Password:', appConfig.postgresPassword ? '[SET]' : '[NOT SET]');
console.log('🔍 PostgreSQL Enable SSL:', appConfig.postgresEnableSsl);
console.log('🔍 PostgreSQL Schema:', appConfig.postgresSchema);

console.log('🔍 =========================================');
console.log('🔍 REDIS CONFIGURATION');
console.log('🔍 =========================================');
console.log('🔍 Redis Host:', appConfig.redisHost);
console.log('🔍 Redis Port:', appConfig.redisPort);
console.log('🔍 Redis Password:', appConfig.redisPassword ? '[SET]' : '[NOT SET]');
console.log('🔍 Redis Username:', appConfig.redisUsername || '[NOT SET]');
console.log('🔍 Redis Database:', appConfig.redisDb);
console.log('🔍 Redis TLS:', appConfig.redisTls);

console.log('🔍 =========================================');
console.log('🔍 SECURITY CONFIGURATION');
console.log('🔍 =========================================');
console.log('🔍 Encryption Key:', appConfig.encryptionKey ? '[SET]' : '[NOT SET]');
console.log('🔍 Webhook Secret Key:', appConfig.webhookSecretKey ? '[SET]' : '[NOT SET]');
console.log('🔍 App Secret Key:', appConfig.appSecretKey ? '[SET]' : '[NOT SET]');

if (!appConfig.encryptionKey) {
  console.log('❌ ERROR: ENCRYPTION_KEY environment variable needs to be set!');
  throw new Error('ENCRYPTION_KEY environment variable needs to be set!');
}

if (!appConfig.webhookSecretKey) {
  console.log('❌ ERROR: WEBHOOK_SECRET_KEY environment variable needs to be set!');
  throw new Error('WEBHOOK_SECRET_KEY environment variable needs to be set!');
}

console.log('✅ All required environment variables are set');
console.log('🔍 =========================================');

export default appConfig;
