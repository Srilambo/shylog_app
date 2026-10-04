const express = require('express');
const router = express.Router();

// Base health & status route
router.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Shylog Backend API is running healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

module.exports = router;
