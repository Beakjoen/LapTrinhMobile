'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('ReservationItems', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      reservation_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Reservations',
          key: 'id'
        },
        onDelete: 'CASCADE'
      },
      menu_item_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'MenuItems',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      quantity: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      price: {
        type: Sequelize.DECIMAL(10, 2),
        allowNull: false
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        field: 'created_at'
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        field: 'updated_at' // Sequelize often expects this, though not explicitly in schema requirements, good to have for consistency
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('ReservationItems');
  }
};
