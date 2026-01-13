'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('MenuItems', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false
      },
      description: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      category: {
        type: Sequelize.ENUM('Khai Vị', 'Món Chính', 'Tráng Miệng', 'Đồ Uống', 'Súp'),
        allowNull: false
      },
      price: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false
      },
      image_url: {
        type: Sequelize.STRING,
        allowNull: true
      },
      preparation_time: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      is_vegetarian: {
        type: Sequelize.BOOLEAN,
        defaultValue: false
      },
      is_spicy: {
        type: Sequelize.BOOLEAN,
        defaultValue: false
      },
      is_available: {
        type: Sequelize.BOOLEAN,
        defaultValue: true
      },
      rating: {
        type: Sequelize.DECIMAL(3, 1),
        defaultValue: 0.0
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        field: 'created_at'
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        field: 'updated_at'
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('MenuItems');
  }
};
