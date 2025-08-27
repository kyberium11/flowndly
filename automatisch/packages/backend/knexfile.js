import { knexSnakeCaseMappers } from 'objection';
import appConfig from './src/config/app.js';
import path, { join } from 'path';
import { fileURLToPath } from 'url';

const fileExtension = 'js';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Configure SSL based on environment
let sslConfig = false;

// For Railway deployments, completely disable SSL for internal connections
if (process.env.APP_ENV === 'production' && process.env.DATABASE_URL) {
  sslConfig = false;
  console.log('🔍 Railway production detected - completely disabling SSL for internal database connection');
} else if (appConfig.postgresEnableSsl) {
  sslConfig = {
    rejectUnauthorized: false // Allow self-signed certificates
  };
}

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

console.log('🔍 Knex SSL configuration:', sslConfig);
console.log('🔍 Database host:', appConfig.postgresHost);
console.log('🔍 Database port:', appConfig.postgresPort);

export default knexConfig;
