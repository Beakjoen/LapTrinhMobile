const Joi = require('joi');

const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });
    if (error) {
      const errors = error.details.map(detail => detail.message);
      return res.status(400).json({ message: 'Validation Error', errors });
    }
    next();
  };
};

const schemas = {
  register: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().min(6).required(),
    full_name: Joi.string().required(),
    phone_number: Joi.string().pattern(/^[0-9]+$/).optional(),
    address: Joi.string().optional()
  }),
  login: Joi.object({
    email: Joi.string().required(),
    password: Joi.string().required()
  }),
  menuItem: Joi.object({
    name: Joi.string().required(),
    description: Joi.string().optional(),
    category: Joi.string().valid('Appetizer', 'Main Course', 'Dessert', 'Beverage', 'Soup').required(),
    price: Joi.number().positive().required(),
    preparation_time: Joi.number().integer().positive().optional(),
    is_vegetarian: Joi.boolean().optional(),
    is_spicy: Joi.boolean().optional(),
    image_url: Joi.string().uri().optional()
  }),
  reservation: Joi.object({
    reservation_date: Joi.date().iso().greater('now').required(),
    number_of_guests: Joi.number().integer().min(1).required(),
    special_requests: Joi.string().allow('').optional()
  }),
  reservationItem: Joi.object({
    menu_item_id: Joi.number().integer().required(),
    quantity: Joi.number().integer().min(1).required()
  }),
  pay: Joi.object({
    payment_method: Joi.string().required(),
    use_loyalty_points: Joi.boolean().required(),
    loyalty_points_to_use: Joi.number().integer().min(0).optional()
  })
};

module.exports = {
  validate,
  schemas
};
