'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Reservations', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      customer_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Customers',
          key: 'id'
        },
        onDelete: 'RESTRICT'
      },
      reservation_number: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true
      },
      reservation_date: {
        type: Sequelize.DATE,
        allowNull: false
      },
      number_of_guests: {
        type: Sequelize.INTEGER,
        allowNull: false
      },
      table_number: {
        type: Sequelize.STRING,
        allowNull: true
      },
      status: {
        type: Sequelize.ENUM('pending', 'confirmed', 'seated', 'completed', 'cancelled', 'no_show'),
        defaultValue: 'pending'
      },
      special_requests: {
        type: Sequelize.TEXT,
        allowNull: true
      },
      subtotal: {
        type: Sequelize.DECIMAL(10, 2),
        defaultValue: 0
      },
      service_charge: {
        type: Sequelize.DECIMAL(10, 2),
        defaultValue: 0
      },
      discount: {
        type: Sequelize.DECIMAL(10, 2),
        defaultValue: 0
      },
      total: {
        type: Sequelize.DECIMAL(10, 2),
        defaultValue: 0
      },
      payment_method: {
        type: Sequelize.STRING,
        allowNull: true
      },
      payment_status: {
        type: Sequelize.STRING,
        defaultValue: 'pending'
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
    await queryInterface.dropTable('Reservations');
  }
};
