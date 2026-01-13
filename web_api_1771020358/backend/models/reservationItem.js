'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ReservationItem extends Model {
    static associate(models) {
      ReservationItem.belongsTo(models.Reservation, { foreignKey: 'reservation_id' });
      ReservationItem.belongsTo(models.MenuItem, { foreignKey: 'menu_item_id', as: 'menu_item' });
    }
  }
  ReservationItem.init({
    reservation_id: { type: DataTypes.INTEGER, allowNull: false },
    menu_item_id: { type: DataTypes.INTEGER, allowNull: false },
    quantity: { type: DataTypes.INTEGER, allowNull: false },
    price: { type: DataTypes.DECIMAL(10, 2), allowNull: false }
  }, {
    sequelize,
    modelName: 'ReservationItem',
    tableName: 'ReservationItems',
    underscored: true,
  });
  return ReservationItem;
};
