const errorHandler = (err, req, res, next) => {
  console.error(err.stack);

  if (err.name === 'SequelizeValidationError') {
    const errors = err.errors.map(e => e.message);
    return res.status(400).json({ message: 'Validation Error', errors });
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    return res.status(409).json({ message: 'Resource already exists' });
  }

  res.status(500).json({ message: 'Internal Server Error', error: err.message });
};

module.exports = errorHandler;
