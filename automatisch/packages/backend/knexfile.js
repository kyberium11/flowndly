import { knexSnakeCaseMappers } from 'objection';
import appConfig from './src/config/app.js';
import path, { join } from 'path';
import { fileURLToPath } from 'url';

const fileExtension = 'js';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

console.log('🔍 =========================================');
console.log('🔍 KNEX DATABASE CONFIGURATION');
console.log('🔍 =========================================');
console.log('🔍 Environment:', process.env.APP_ENV);
console.log('🔍 DATABASE_URL present:', !!process.env.DATABASE_URL);
console.log('🔍 appConfig.postgresEnableSsl:', appConfig.postgresEnableSsl);

// Configure SSL based on environment
let sslConfig = false;

// For Railway deployments, use the official solution: rejectUnauthorized: false
if (process.env.APP_ENV === 'production' && process.env.DATABASE_URL) {
  sslConfig = {
    rejectUnauthorized: false // Official Railway solution for self-signed certificates
  };
  console.log('🔍 Railway production detected - using ssl: { rejectUnauthorized: false }');
  console.log('🔍 This is the official Railway solution for self-signed certificates');
} else if (appConfig.postgresEnableSsl) {
  sslConfig = {
    rejectUnauthorized: false // Allow self-signed certificates
  };
  console.log('🔍 SSL enabled with rejectUnauthorized: false for local/other environments');
} else {
  console.log('🔍 SSL disabled for this environment');
}

console.log('🔍 Final SSL configuration:', JSON.stringify(sslConfig, null, 2));

const knexConfig = {
  client: 'pg',
  connection: {
    host: appConfig.postgresHost,
    port: appConfig.postgresPort,
    user: appConfig.postgresUsername,
    password: appConfig.postgresPassword,
    database: appConfig.postgresDatabase,
    ssl: sslConfig,
  },
  asyncStackTraces: appConfig.isDev,
  searchPath: [appConfig.postgresSchema],
  pool: { min: 0, max: 20 },
  migrations: {
    directory: join(__dirname, '/src/db/migrations'),
    extension: fileExtension,
    loadExtensions: [`.${fileExtension}`],
  },
  seeds: {
    directory: join(__dirname, '/src/db/seeds'),
  },
  ...(appConfig.isTest ? knexSnakeCaseMappers() : {}),
};

console.log('🔍 =========================================');
console.log('🔍 DATABASE CONNECTION DETAILS');
console.log('🔍 =========================================');
console.log('🔍 Database host:', appConfig.postgresHost);
console.log('🔍 Database port:', appConfig.postgresPort);
console.log('🔍 Database name:', appConfig.postgresDatabase);
console.log('🔍 Database user:', appConfig.postgresUsername);
console.log('🔍 Database password:', appConfig.postgresPassword ? '[SET]' : '[NOT SET]');
console.log('🔍 SSL configuration:', JSON.stringify(sslConfig, null, 2));
console.log('🔍 Pool configuration:', JSON.stringify(knexConfig.pool, null, 2));
console.log('🔍 =========================================');

export default knexConfig;
