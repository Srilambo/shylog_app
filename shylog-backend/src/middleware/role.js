const ApiError = require('../utils/ApiError');

const roleHierarchy = {
  customer: 1,
  staff: 2,
  admin: 3,
  superadmin: 4,
};

const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return next(new ApiError(401, 'User not authenticated'));
    }

    if (!allowedRoles.includes(req.user.role)) {
      return next(
        new ApiError(
          403,
          `Role (${req.user.role}) is not authorized to perform this action`
        )
      );
    }

    next();
  };
};

const restrictToMinimumRole = (minRole) => {
  return (req, res, next) => {
    if (!req.user) {
      return next(new ApiError(401, 'User not authenticated'));
    }

    const userLevel = roleHierarchy[req.user.role] || 0;
    const requiredLevel = roleHierarchy[minRole] || 0;

    if (userLevel < requiredLevel) {
      return next(
        new ApiError(
          403,
          `Requires minimum role of ${minRole}`
        )
      );
    }

    next();
  };
};

module.exports = { authorize, restrictToMinimumRole };
