const { Customer, Reservation, ReservationItem, MenuItem } = require('../../models');

const getAllCustomers = async (req, res, next) => {
  try {
    const customers = await Customer.findAll({ attributes: { exclude: ['password'] } });
    res.json(customers);
  } catch (error) {
    next(error);
  }
};

const getCustomerById = async (req, res, next) => {
  try {
    const { id } = req.params;
    // Authorization check: Admin or Self
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    const customer = await Customer.findByPk(id, { attributes: { exclude: ['password'] } });
    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }
    res.json(customer);
  } catch (error) {
    next(error);
  }
};

const updateCustomer = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    const customer = await Customer.findByPk(id);
    if (!customer) {
      return res.status(404).json({ message: 'Customer not found' });
    }

    const { full_name, phone_number, address } = req.body;
    await customer.update({ full_name, phone_number, address });

    const { password: _, ...customerData } = customer.toJSON();
    res.json(customerData);
  } catch (error) {
    next(error);
  }
};

const getCustomerReservations = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
      return res.status(403).json({ message: 'Forbidden' });
    }

    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const { status } = req.query;

    const where = { customer_id: id };
    if (status) where.status = status;

    const { count, rows } = await Reservation.findAndCountAll({
      where,
      include: [{
        model: ReservationItem,
        as: 'items',
        include: [{ model: MenuItem, as: 'menu_item' }]
      }],
      limit,
      offset,
      order: [['created_at', 'DESC']]
    });

    res.json({
      total: count,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
      reservations: rows
    });

  } catch (error) {
    next(error);
  }
}

module.exports = {
  getAllCustomers,
  getCustomerById,
  updateCustomer,
  getCustomerReservations
};
