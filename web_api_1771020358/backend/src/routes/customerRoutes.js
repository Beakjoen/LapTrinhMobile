const express = require('express');
const router = express.Router();
const customerController = require('../controllers/customerController');
const { authenticate, authorize } = require('../middlewares/authMiddleware');

router.get('/', authenticate, authorize('admin'), customerController.getAllCustomers);
router.get('/:id', authenticate, customerController.getCustomerById);
router.put('/:id', authenticate, customerController.updateCustomer);
router.get('/:id/reservations', authenticate, customerController.getCustomerReservations);

module.exports = router;
