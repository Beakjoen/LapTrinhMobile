'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Table extends Model {
    static associate(models) {
      // define association here
    }
  }
  Table.init({
    table_number: { type: DataTypes.STRING, allowNull: false, unique: true },
    capacity: { type: DataTypes.INTEGER, allowNull: false },
    is_available: { type: DataTypes.BOOLEAN, defaultValue: true }
  }, {
    sequelize,
    modelName: 'Table',
    tableName: 'Tables',
    underscored: true,
  });
  return Table;
};
