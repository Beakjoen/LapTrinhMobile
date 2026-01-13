const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Customer } = require('../../models');

const register = async (req, res, next) => {
  try {
    const { email, password, full_name, phone_number, address } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const customer = await Customer.create({
      email,
      password: hashedPassword,
      full_name,
      phone_number,
      address,
      role: 'customer'
    });

    const { password: _, ...customerData } = customer.toJSON();

    res.status(201).json({ message: 'User registered successfully', customer: customerData });
  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const customer = await Customer.findOne({ where: { email } });

    if (!customer || !(await bcrypt.compare(password, customer.password))) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    if (!customer.is_active) {
      return res.status(403).json({ message: 'Account is inactive' });
    }

    const token = jwt.sign({ id: customer.id, role: customer.role }, process.env.JWT_SECRET, { expiresIn: '24h' });
    const { password: _, ...customerData } = customer.toJSON();

    res.json({
      token,
      user: customerData,
      student_id: process.env.STUDENT_ID || '1771020358'
    });
  } catch (error) {
    next(error);
  }
};

const getMe = async (req, res, next) => {
  try {
    const { password: _, ...customerData } = req.user.toJSON();
    res.json(customerData);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  getMe
};
