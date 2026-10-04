const mongoose = require('mongoose');
const env = require('./env');
const logger = require('../utils/logger');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(env.mongoUri, {
      serverSelectionTimeoutMS: 4000,
    });
    logger.info(`MongoDB Connected: ${conn.connection.host}/${conn.connection.name}`);
  } catch (error) {
    logger.error(`MongoDB Connection Error: ${error.message}`);
    if (env.env === 'production') {
      process.exit(1);
    } else {
      logger.warn('Running in development mode without active MongoDB. Update MONGO_URI in .env with a valid MongoDB Atlas connection string.');
    }
  }
};

module.exports = connectDB;
