const { MenuItem, ReservationItem, Reservation, Sequelize } = require('../../models');
const { Op } = Sequelize;

const getAllMenuItems = async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const { search, category, vegetarian_only, spicy_only, available_only } = req.query;
    const where = {};

    if (search) {
      where[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { description: { [Op.like]: `%${search}%` } }
      ];
    }
    if (category) where.category = category;
    if (vegetarian_only === 'true') where.is_vegetarian = true;
    if (spicy_only === 'true') where.is_spicy = true;
    if (available_only === 'true') where.is_available = true;

    const { count, rows } = await MenuItem.findAndCountAll({
      where,
      limit,
      offset
    });

    res.json({
      total: count,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
      menuItems: rows
    });
  } catch (error) {
    next(error);
  }
};

const getMenuItemById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const menuItem = await MenuItem.findByPk(id);
    if (!menuItem) return res.status(404).json({ message: 'Menu item not found' });
    res.json(menuItem);
  } catch (error) {
    next(error);
  }
};

const createMenuItem = async (req, res, next) => {
  try {
    const menuItem = await MenuItem.create(req.body);
    res.status(201).json(menuItem);
  } catch (error) {
    next(error);
  }
};

const updateMenuItem = async (req, res, next) => {
  try {
    const { id } = req.params;
    const menuItem = await MenuItem.findByPk(id);
    if (!menuItem) return res.status(404).json({ message: 'Menu item not found' });
    await menuItem.update(req.body);
    res.json(menuItem);
  } catch (error) {
    next(error);
  }
};

const deleteMenuItem = async (req, res, next) => {
  try {
    const { id } = req.params;
    const menuItem = await MenuItem.findByPk(id);
    if (!menuItem) return res.status(404).json({ message: 'Menu item not found' });

    const activeReservation = await ReservationItem.findOne({
      where: { menu_item_id: id },
      include: [{
        model: Reservation,
        where: {
          status: { [Op.in]: ['pending', 'confirmed', 'seated'] }
        }
      }]
    });

    if (activeReservation) {
      return res.status(400).json({ message: 'Cannot delete menu item associated with active reservations' });
    }

    await menuItem.destroy();
    res.json({ message: 'Menu item deleted' });
  } catch (error) {
    next(error);
  }
};

const searchMenuItems = async (req, res, next) => {
  try {
    const { q } = req.query;
    const search = q || req.query.search;

    const where = {};
    if (search) {
      where[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { description: { [Op.like]: `%${search}%` } }
      ];
    }
    const items = await MenuItem.findAll({ where });
    res.json(items);
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getAllMenuItems,
  getMenuItemById,
  createMenuItem,
  updateMenuItem,
  deleteMenuItem,
  searchMenuItems
};
