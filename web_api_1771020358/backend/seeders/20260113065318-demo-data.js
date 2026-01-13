'use strict';
const bcrypt = require('bcrypt');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    const hashedPassword = await bcrypt.hash('password123', 10);

    // 1. Khách hàng
    const customers = [];
    for (let i = 1; i <= 5; i++) {
      customers.push({
        email: `khachhang${i}@example.com`,
        password: hashedPassword,
        full_name: `Khách hàng ${i}`,
        phone_number: `012345678${i}`,
        address: `Địa chỉ ${i}`,
        role: i === 1 ? 'admin' : 'customer',
        created_at: new Date(),
        updated_at: new Date()
      });
    }
    await queryInterface.bulkInsert('Customers', customers, {});

    // 2. Bàn ăn
    const tables = [];
    for (let i = 1; i <= 8; i++) {
      tables.push({
        table_number: `Bàn 0${i}`,
        capacity: i % 2 === 0 ? 4 : 2,
        is_available: true,
        created_at: new Date(),
        updated_at: new Date()
      });
    }
    await queryInterface.bulkInsert('Tables', tables, {});

    // 3. Thực đơn (Dữ liệu tiếng Việt)
    const curatedMenuItems = [
      {
        name: "Phở Bò Đặc Biệt",
        description: "Phở bò truyền thống với thịt bò tái, nạm, gầu và nước dùng đậm đà.",
        category: "Món Chính",
        price: 85000,
        image_url: "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 15,
        is_vegetarian: false,
        is_spicy: false
      },
      {
        name: "Bún Chả Hà Nội",
        description: "Bún chả với thịt nướng than hoa, chả viên và nước chấm chua ngọt.",
        category: "Món Chính",
        price: 90000,
        image_url: "https://images.unsplash.com/photo-1580476262798-bddd9dd90d3e?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 20,
        is_vegetarian: false,
        is_spicy: false
      },
      {
        name: "Gỏi Cuốn Tôm Thịt",
        description: "Gỏi cuốn tươi ngon với tôm, thịt ba chỉ, bún và rau sống.",
        category: "Khai Vị",
        price: 70000,
        image_url: "https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 10,
        is_vegetarian: false,
        is_spicy: false
      },
      {
        name: "Bánh Xèo Miền Tây",
        description: "Bánh xèo giòn rụm nhân tôm thịt, ăn kèm rau sống và nước mắm.",
        category: "Món Chính",
        price: 80000,
        image_url: "https://images.unsplash.com/photo-1519708227418-c8fd9a3a2749?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 25,
        is_vegetarian: false,
        is_spicy: false
      },
      {
        name: "Cơm Tấm Sườn Bì",
        description: "Cơm tấm sườn nướng, bì, chả trứng và mỡ hành.",
        category: "Món Chính",
        price: 75000,
        image_url: "https://images.unsplash.com/photo-1631709497146-a239ef373cf1?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 15,
        is_vegetarian: false,
        is_spicy: false
      },
      {
        name: "Chè Ba Màu",
        description: "Món tráng miệng truyền thống với đậu xanh, đậu đỏ và thạch.",
        category: "Tráng Miệng",
        price: 35000,
        image_url: "https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 5,
        is_vegetarian: true,
        is_spicy: false
      },
      {
        name: "Cà Phê Sữa Đá",
        description: "Cà phê Việt Nam đậm đà pha với sữa đặc và đá.",
        category: "Đồ Uống",
        price: 40000,
        image_url: "https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 5,
        is_vegetarian: true,
        is_spicy: false
      },
      {
        name: "Súp Bí Đỏ",
        description: "Súp bí đỏ kem béo ngậy, tốt cho sức khỏe.",
        category: "Súp",
        price: 55000,
        image_url: "https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 15,
        is_vegetarian: true,
        is_spicy: false
      },
      {
        name: "Rau Muống Xào Tỏi",
        description: "Rau muống tươi xanh xào với tỏi thơm lừng.",
        category: "Món Chính",
        price: 50000,
        image_url: "https://images.unsplash.com/photo-1555126634-323283e090fa?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 10,
        is_vegetarian: true,
        is_spicy: false
      },
      {
        name: "Lẩu Thái Hải Sản",
        description: "Lẩu chua cay với tôm, mực, nghêu và rau nấm.",
        category: "Món Chính",
        price: 350000,
        image_url: "https://images.unsplash.com/photo-1546241072-48010ad28d5a?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 30,
        is_vegetarian: false,
        is_spicy: true
      },
      {
        name: "Trà Đào Cam Sả",
        description: "Trà đào thanh mát kết hợp với cam tươi và sả.",
        category: "Đồ Uống",
        price: 45000,
        image_url: "https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 5,
        is_vegetarian: true,
        is_spicy: false
      },
      {
        name: "Bánh Flan",
        description: "Bánh flan mềm mịn, thơm mùi trứng sữa và caramel.",
        category: "Tráng Miệng",
        price: 30000,
        image_url: "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?q=80&w=1000&auto=format&fit=crop",
        preparation_time: 0,
        is_vegetarian: true,
        is_spicy: false
      }
    ];

    const menuItems = curatedMenuItems.map(item => ({
      ...item,
      is_available: true,
      rating: (Math.random() * 1.5 + 3.5).toFixed(1), // Rating 3.5 - 5.0
      created_at: new Date(),
      updated_at: new Date()
    }));

    await queryInterface.bulkInsert('MenuItems', menuItems, {});

    // 4. Đặt bàn
    const reservations = [];
    for (let i = 1; i <= 10; i++) {
      reservations.push({
        customer_id: (i % 5) + 1,
        reservation_number: `RES-20240115-${i.toString().padStart(3, '0')}`,
        reservation_date: new Date(),
        number_of_guests: 2,
        table_number: null,
        status: 'pending',
        special_requests: 'Không có',
        subtotal: 0,
        total: 0,
        created_at: new Date(),
        updated_at: new Date()
      });
    }
    await queryInterface.bulkInsert('Reservations', reservations, {});

    // 5. Chi tiết đặt bàn
    const reservationItems = [];
    for (let i = 1; i <= 10; i++) {
      reservationItems.push({
        reservation_id: i,
        menu_item_id: (i % menuItems.length) + 1,
        quantity: 1,
        price: menuItems[(i % menuItems.length)].price,
        created_at: new Date(),
        updated_at: new Date()
      });
    }
    await queryInterface.bulkInsert('ReservationItems', reservationItems, {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('ReservationItems', null, {});
    await queryInterface.bulkDelete('Reservations', null, {});
    await queryInterface.bulkDelete('MenuItems', null, {});
    await queryInterface.bulkDelete('Tables', null, {});
    await queryInterface.bulkDelete('Customers', null, {});
  }
};
