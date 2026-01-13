const { Table } = require('../../models');

const getAllTables = async (req, res, next) => {
  try {
    const { available_only } = req.query;
    const where = {};
    if (available_only === 'true') {
      where.is_available = true;
    }
    const tables = await Table.findAll({ where });
    res.json(tables);
  } catch (error) {
    next(error);
  }
};

const createTable = async (req, res, next) => {
  try {
    const table = await Table.create(req.body);
    res.status(201).json(table);
  } catch (error) {
    next(error);
  }
};

const updateTable = async (req, res, next) => {
  try {
    const { id } = req.params;
    const table = await Table.findByPk(id);
    if (!table) return res.status(404).json({ message: 'Table not found' });
    await table.update(req.body);
    res.json(table);
  } catch (error) {
    next(error);
  }
};

const deleteTable = async (req, res, next) => {
  try {
    const { id } = req.params;
    const table = await Table.findByPk(id);
    if (!table) return res.status(404).json({ message: 'Table not found' });
    await table.destroy();
    res.json({ message: 'Table deleted' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllTables,
  createTable,
  updateTable,
  deleteTable
};
