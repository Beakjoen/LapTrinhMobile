'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Reservation extends Model {
    static associate(models) {
      Reservation.belongsTo(models.Customer, { foreignKey: 'customer_id', as: 'customer' });
      Reservation.hasMany(models.ReservationItem, { foreignKey: 'reservation_id', as: 'items' });
    }
  }
  Reservation.init({
    customer_id: { type: DataTypes.INTEGER, allowNull: false },
    reservation_number: { type: DataTypes.STRING, allowNull: false, unique: true },
    reservation_date: { type: DataTypes.DATE, allowNull: false },
    number_of_guests: { type: DataTypes.INTEGER, allowNull: false },
    table_number: DataTypes.STRING,
    status: {
      type: DataTypes.ENUM('pending', 'confirmed', 'seated', 'completed', 'cancelled', 'no_show'),
      defaultValue: 'pending'
    },
    special_requests: DataTypes.TEXT,
    subtotal: { type: DataTypes.DECIMAL(10, 2), defaultValue: 0 },
    service_charge: { type: DataTypes.DECIMAL(10, 2), defaultValue: 0 },
    discount: { type: DataTypes.DECIMAL(10, 2), defaultValue: 0 },
    total: { type: DataTypes.DECIMAL(10, 2), defaultValue: 0 },
    payment_method: DataTypes.STRING,
    payment_status: { type: DataTypes.STRING, defaultValue: 'pending' }
  }, {
    sequelize,
    modelName: 'Reservation',
    tableName: 'Reservations',
    underscored: true,
  });
  return Reservation;
};
