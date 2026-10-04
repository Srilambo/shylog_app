const ApiError = require('../utils/ApiError');

const validate = (schema, property = 'body') => {
  return (req, res, next) => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true, // Prevents mass assignment vulnerabilities
    });

    if (error) {
      const errorMessages = error.details.map((detail) => detail.message);
      return next(new ApiError(400, 'Validation Error', errorMessages));
    }

    req[property] = value;
    next();
  };
};

module.exports = validate;
