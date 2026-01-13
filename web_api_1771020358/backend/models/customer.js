'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Customer extends Model {
    static associate(models) {
      Customer.hasMany(models.Reservation, { foreignKey: 'customer_id', as: 'reservations' });
    }
  }
  Customer.init({
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING, allowNull: false },
    full_name: { type: DataTypes.STRING, allowNull: false },
    phone_number: DataTypes.STRING,
    address: DataTypes.STRING,
    loyalty_points: { type: DataTypes.INTEGER, defaultValue: 0 },
    is_active: { type: DataTypes.BOOLEAN, defaultValue: true },
    role: { type: DataTypes.STRING, defaultValue: 'customer' } // Added role
  }, {
    sequelize,
    modelName: 'Customer',
    tableName: 'Customers',
    underscored: true,
  });
  return Customer;
};
