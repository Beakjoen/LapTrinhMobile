'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class MenuItem extends Model {
    static associate(models) {
      MenuItem.hasMany(models.ReservationItem, { foreignKey: 'menu_item_id' });
    }
  }
  MenuItem.init({
    name: { type: DataTypes.STRING, allowNull: false },
    description: DataTypes.TEXT,
    category: { type: DataTypes.ENUM('Khai Vị', 'Món Chính', 'Tráng Miệng', 'Đồ Uống', 'Súp'), allowNull: false },
    price: { type: DataTypes.DECIMAL(10, 2), allowNull: false },
    image_url: DataTypes.STRING,
    preparation_time: DataTypes.INTEGER,
    is_vegetarian: { type: DataTypes.BOOLEAN, defaultValue: false },
    is_spicy: { type: DataTypes.BOOLEAN, defaultValue: false },
    is_available: { type: DataTypes.BOOLEAN, defaultValue: true },
    rating: { type: DataTypes.DECIMAL(3, 1), defaultValue: 0.0 }
  }, {
    sequelize,
    modelName: 'MenuItem',
    tableName: 'MenuItems',
    underscored: true,
  });
  return MenuItem;
};
