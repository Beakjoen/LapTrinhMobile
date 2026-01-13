const express = require('express');
const router = express.Router();
const menuController = require('../controllers/menuController');
const { authenticate, authorize } = require('../middlewares/authMiddleware');

const { validate, schemas } = require('../middlewares/validationMiddleware');

router.get('/search', menuController.searchMenuItems);
router.get('/', menuController.getAllMenuItems);
router.get('/:id', menuController.getMenuItemById);
router.post('/', authenticate, authorize('admin'), validate(schemas.menuItem), menuController.createMenuItem);
router.put('/:id', authenticate, authorize('admin'), validate(schemas.menuItem), menuController.updateMenuItem);
router.delete('/:id', authenticate, authorize('admin'), menuController.deleteMenuItem);

module.exports = router;
