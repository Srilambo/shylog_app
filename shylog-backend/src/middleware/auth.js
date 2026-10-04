const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User');
const ApiError = require('../utils/ApiError');
const asyncHandler = require('../utils/asyncHandler');

const protect = asyncHandler(async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies && req.cookies.refreshToken) {
    // Optional cookie check for web sessions
    token = req.cookies.accessToken;
  }

  if (!token) {
    throw new ApiError(401, 'Authentication token missing or invalid');
  }

  try {
    const decoded = jwt.verify(token, env.jwt.accessSecret);
    const user = await User.findById(decoded.id);

    if (!user) {
      throw new ApiError(401, 'User associated with token no longer exists');
    }

    if (user.isBlocked) {
      throw new ApiError(403, 'Account is suspended. Please contact support.');
    }

    if (user.isLocked()) {
      throw new ApiError(423, 'Account is temporarily locked due to multiple failed login attempts');
    }

    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      throw new ApiError(401, 'Token has expired');
    }
    throw new ApiError(401, 'Not authorized, invalid token');
  }
});

module.exports = { protect };
