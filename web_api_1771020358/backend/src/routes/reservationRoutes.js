const express = require('express');
const router = express.Router();
const reservationController = require('../controllers/reservationController');
const { authenticate, authorize } = require('../middlewares/authMiddleware');

const { validate, schemas } = require('../middlewares/validationMiddleware');

router.post('/', authenticate, validate(schemas.reservation), reservationController.createReservation);
router.post('/:id/items', authenticate, validate(schemas.reservationItem), reservationController.addItemsToReservation);
router.put('/:id/confirm', authenticate, authorize('admin'), reservationController.confirmReservation);
router.get('/:id', authenticate, reservationController.getReservationById);
router.post('/:id/pay', authenticate, validate(schemas.pay), reservationController.payReservation);
router.delete('/:id', authenticate, reservationController.cancelReservation);

module.exports = router;
