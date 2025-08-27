import { knexSnakeCaseMappers } from 'objection';
import appConfig from './src/config/app.js';
import path, { join } from 'path';
import { fileURLToPath } from 'url';

const fileExtension = 'js';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Configure SSL based on environment
let sslConfig = false;
if (appConfig.postgresEnableSsl) {
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

export default knexConfig;
