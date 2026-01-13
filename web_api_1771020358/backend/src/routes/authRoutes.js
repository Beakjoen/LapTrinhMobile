const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authenticate } = require('../middlewares/authMiddleware');

const { validate, schemas } = require('../middlewares/validationMiddleware');

router.post('/register', validate(schemas.register), authController.register);
router.post('/login', validate(schemas.login), authController.login);
router.get('/me', authenticate, authController.getMe);

module.exports = router;
