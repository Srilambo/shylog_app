const app = require('./app');
const env = require('./config/env');
const connectDB = require('./config/db');
const logger = require('./utils/logger');

// Connect to MongoDB
connectDB();

const PORT = env.port || 5000;

const server = app.listen(PORT, () => {
  logger.info(`===============================================`);
  logger.info(`🚀 Shylog Backend API Server is running!`);
  logger.info(`🌐 Mode: ${env.env}`);
  logger.info(`📡 Port: ${PORT}`);
  logger.info(`🔗 Base URL: http://localhost:${PORT}/api/${env.apiVersion}`);
  logger.info(`💚 Health: http://localhost:${PORT}/health`);
  logger.info(`===============================================`);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  logger.error(`Unhandled Rejection: ${err.message}`);
  if (err.stack) {
    logger.error(err.stack);
  }
});

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  logger.error(`Uncaught Exception: ${err.message}`);
  if (err.stack) {
    logger.error(err.stack);
  }
  process.exit(1);
});

// Handle termination signals
process.on('SIGTERM', () => {
  logger.info('SIGTERM received. Shutting down gracefully...');
  server.close(() => {
    logger.info('Process terminated.');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT received. Shutting down gracefully...');
  server.close(() => {
    logger.info('Process terminated.');
    process.exit(0);
  });
});

module.exports = server;
