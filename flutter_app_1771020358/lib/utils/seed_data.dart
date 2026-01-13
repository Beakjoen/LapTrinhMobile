// Script để seed dữ liệu mẫu vào Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed chỉ customers
  Future<List<String>> seedCustomersOnly() async {
    print('📝 Đang seed customers...');
    final customerIds = await seedCustomers();
    print('✅ Đã seed ${customerIds.length} customers');
    return customerIds;
  }

  /// Seed chỉ menu items
  Future<List<String>> seedMenuItemsOnly() async {
    print('📝 Đang seed menu items...');
    final menuItemIds = await seedMenuItems();
    print('✅ Đã seed ${menuItemIds.length} menu items');
    return menuItemIds;
  }

  /// Seed tất cả dữ liệu mẫu
  Future<void> seedAll() async {
    try {
      print('🌱 Bắt đầu seed dữ liệu...');
      
      // Kiểm tra kết nối Firestore bằng cách thử write một document test
      try {
        final testRef = _firestore.collection('_seed_test').doc('connection_test');
        await testRef.set({'test': true, 'timestamp': FieldValue.serverTimestamp()});
        await testRef.delete();
        print('✓ Firestore connection và write permission OK');
      } catch (e) {
        print('⚠️ Firestore connection/write test failed: $e');
        if (e.toString().contains('permission-denied') || 
            e.toString().contains('PERMISSION_DENIED')) {
          throw Exception(
            'Firestore Rules không cho phép write. '
            'Vui lòng cập nhật rules trong Firebase Console để cho phép write.'
          );
        }
        // Vẫn tiếp tục nếu không phải lỗi permission
      }

      // Xóa dữ liệu cũ (tùy chọn)
      // await _clearAllData();

      // Seed customers
      print('📝 Đang seed customers...');
      final customerIds = await seedCustomers();
      print('✅ Đã seed ${customerIds.length} customers');

      // Seed menu items
      print('📝 Đang seed menu items...');
      final menuItemIds = await seedMenuItems();
      print('✅ Đã seed ${menuItemIds.length} menu items');

      // Seed reservations
      if (customerIds.isNotEmpty && menuItemIds.isNotEmpty) {
        print('📝 Đang seed reservations...');
        final reservationIds = await seedReservations(
          customerIds[0],
          menuItemIds,
        );
        print('✅ Đã seed ${reservationIds.length} reservations');
      } else {
        print('⚠️ Không thể seed reservations: thiếu customers hoặc menu items');
      }

      print('🎉 Hoàn thành seed dữ liệu!');
    } catch (e, stackTrace) {
      print('❌ Lỗi khi seed dữ liệu: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Seed customers với batch write để tăng tốc
  Future<List<String>> seedCustomers() async {
    final List<String> customerIds = [];
    
    final customers = [
      {
        'email': 'nguyenvana@example.com',
        'fullName': 'Nguyễn Văn A',
        'phoneNumber': '0123456789',
        'address': '123 Đường ABC, Quận 1, TP.HCM',
        'preferences': ['vegetarian', 'spicy'],
        'loyaltyPoints': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      },
      {
        'email': 'tranthib@example.com',
        'fullName': 'Trần Thị B',
        'phoneNumber': '0987654321',
        'address': '456 Đường XYZ, Quận 2, TP.HCM',
        'preferences': ['seafood'],
        'loyaltyPoints': 500,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      },
      {
        'email': 'levanc@example.com',
        'fullName': 'Lê Văn C',
        'phoneNumber': '0912345678',
        'address': '789 Đường DEF, Quận 3, TP.HCM',
        'preferences': ['spicy'],
        'loyaltyPoints': 1200,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      },
      {
        'email': 'phamthid@example.com',
        'fullName': 'Phạm Thị D',
        'phoneNumber': '0923456789',
        'address': '321 Đường GHI, Quận 4, TP.HCM',
        'preferences': ['vegetarian'],
        'loyaltyPoints': 300,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      },
    ];

    // Sử dụng batch write để tăng tốc (tối đa 500 operations per batch)
    final batch = _firestore.batch();
    final customerRefs = <String>[];
    
    for (final customerData in customers) {
      final docRef = _firestore.collection('customers').doc();
      customerRefs.add(docRef.id);
      batch.set(docRef, customerData);
    }
    
    await batch.commit();
    
    for (int i = 0; i < customers.length; i++) {
      customerIds.add(customerRefs[i]);
      print('  ✓ Customer: ${customers[i]['fullName']} (${customerRefs[i]})');
    }

    return customerIds;
  }

  /// Seed menu items
  Future<List<String>> seedMenuItems() async {
    final menuItems = [
      // Appetizers
      {
        'name': 'Gỏi Cuốn',
        'description': 'Gỏi cuốn tôm thịt tươi ngon với bánh tráng và rau sống',
        'category': 'Appetizer',
        'price': 35000.0,
        'imageUrl': '',
        'ingredients': ['bánh tráng', 'tôm', 'thịt', 'rau sống', 'bún', 'nước mắm'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 10,
        'isAvailable': true,
        'rating': 4.7,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Chả Giò',
        'description': 'Chả giò giòn rụm, nhân thịt heo và tôm',
        'category': 'Appetizer',
        'price': 40000.0,
        'imageUrl': '',
        'ingredients': ['bánh tráng', 'thịt heo', 'tôm', 'nấm', 'cà rốt'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Gỏi Đu Đủ',
        'description': 'Gỏi đu đủ chua ngọt, tươi mát',
        'category': 'Appetizer',
        'price': 30000.0,
        'imageUrl': '',
        'ingredients': ['đu đủ', 'tôm khô', 'rau thơm', 'đậu phộng', 'nước mắm'],
        'isVegetarian': false,
        'isSpicy': true,
        'preparationTime': 8,
        'isAvailable': true,
        'rating': 4.3,
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Main Courses
      {
        'name': 'Phở Bò',
        'description': 'Phở bò truyền thống Việt Nam với nước dùng đậm đà, thịt bò tái',
        'category': 'Main Course',
        'price': 50000.0,
        'imageUrl': '',
        'ingredients': ['bánh phở', 'thịt bò', 'hành', 'rau thơm', 'chanh', 'ớt'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Phở Gà',
        'description': 'Phở gà thơm ngon, nước dùng trong, thịt gà mềm',
        'category': 'Main Course',
        'price': 45000.0,
        'imageUrl': '',
        'ingredients': ['bánh phở', 'thịt gà', 'hành', 'rau thơm', 'chanh'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 12,
        'isAvailable': true,
        'rating': 4.3,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bún Bò Huế',
        'description': 'Bún bò Huế cay nồng đậm đà, đặc trưng miền Trung',
        'category': 'Main Course',
        'price': 55000.0,
        'imageUrl': '',
        'ingredients': ['bún', 'thịt bò', 'chả', 'rau thơm', 'ớt', 'sả'],
        'isVegetarian': false,
        'isSpicy': true,
        'preparationTime': 20,
        'isAvailable': true,
        'rating': 4.8,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bún Chả',
        'description': 'Bún chả Hà Nội với thịt nướng thơm lừng',
        'category': 'Main Course',
        'price': 60000.0,
        'imageUrl': '',
        'ingredients': ['bún', 'thịt nướng', 'rau sống', 'nước mắm pha'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 18,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Cơm Tấm',
        'description': 'Cơm tấm sườn nướng, bì, chả trứng',
        'category': 'Main Course',
        'price': 55000.0,
        'imageUrl': '',
        'ingredients': ['cơm tấm', 'sườn nướng', 'bì', 'chả trứng', 'đồ chua'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 15,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bánh Mì Thịt Nướng',
        'description': 'Bánh mì giòn với thịt nướng, pate, chả lụa',
        'category': 'Main Course',
        'price': 35000.0,
        'imageUrl': '',
        'ingredients': ['bánh mì', 'thịt nướng', 'pate', 'chả lụa', 'rau', 'đồ chua'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Soups
      {
        'name': 'Canh Chua Cá',
        'description': 'Canh chua cá lóc chua ngọt, đậm đà',
        'category': 'Soup',
        'price': 60000.0,
        'imageUrl': '',
        'ingredients': ['cá lóc', 'cà chua', 'dứa', 'đậu bắp', 'rau thơm', 'me'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 25,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Canh Khổ Qua',
        'description': 'Canh khổ qua nhồi thịt, thanh mát',
        'category': 'Soup',
        'price': 50000.0,
        'imageUrl': '',
        'ingredients': ['khổ qua', 'thịt heo', 'nấm', 'hành'],
        'isVegetarian': false,
        'isSpicy': false,
        'preparationTime': 30,
        'isAvailable': true,
        'rating': 4.2,
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Desserts
      {
        'name': 'Chè Đậu Xanh',
        'description': 'Chè đậu xanh mát lạnh, ngọt thanh',
        'category': 'Dessert',
        'price': 20000.0,
        'imageUrl': '',
        'ingredients': ['đậu xanh', 'đường', 'dừa', 'đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.2,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Chè Ba Màu',
        'description': 'Chè ba màu đậm đà, nhiều lớp',
        'category': 'Dessert',
        'price': 25000.0,
        'imageUrl': '',
        'ingredients': ['đậu xanh', 'đậu đỏ', 'thạch', 'nước cốt dừa', 'đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bánh Flan',
        'description': 'Bánh flan mềm mịn, thơm ngon',
        'category': 'Dessert',
        'price': 30000.0,
        'imageUrl': '',
        'ingredients': ['trứng', 'sữa', 'đường', 'caramel'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 3,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': FieldValue.serverTimestamp(),
      },

      // Beverages
      {
        'name': 'Cà Phê Sữa Đá',
        'description': 'Cà phê sữa đá đậm đà phong cách Việt Nam',
        'category': 'Beverage',
        'price': 25000.0,
        'imageUrl': '',
        'ingredients': ['cà phê', 'sữa đặc', 'đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 3,
        'isAvailable': true,
        'rating': 4.6,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Cà Phê Đen Đá',
        'description': 'Cà phê đen đá nguyên chất',
        'category': 'Beverage',
        'price': 20000.0,
        'imageUrl': '',
        'ingredients': ['cà phê', 'đá'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 3,
        'isAvailable': true,
        'rating': 4.4,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Nước Cam Ép',
        'description': 'Nước cam ép tươi, giàu vitamin C',
        'category': 'Beverage',
        'price': 30000.0,
        'imageUrl': '',
        'ingredients': ['cam tươi', 'đá', 'đường'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.5,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sinh Tố Bơ',
        'description': 'Sinh tố bơ béo ngậy, mát lạnh',
        'category': 'Beverage',
        'price': 35000.0,
        'imageUrl': '',
        'ingredients': ['bơ', 'sữa', 'đá', 'sữa đặc'],
        'isVegetarian': true,
        'isSpicy': false,
        'preparationTime': 5,
        'isAvailable': true,
        'rating': 4.7,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    final List<String> menuItemIds = [];
    
    // Sử dụng batch write (chia thành nhiều batch nếu > 500 items)
    const batchSize = 500;
    for (int i = 0; i < menuItems.length; i += batchSize) {
      final batch = _firestore.batch();
      final end = (i + batchSize < menuItems.length) ? i + batchSize : menuItems.length;
      final batchRefs = <String>[];
      
      for (int j = i; j < end; j++) {
        final itemData = menuItems[j];
        final docRef = _firestore.collection('menu_items').doc();
        batchRefs.add(docRef.id);
        batch.set(docRef, itemData);
      }
      
      await batch.commit();
      
      for (int j = 0; j < batchRefs.length; j++) {
        menuItemIds.add(batchRefs[j]);
        print('  ✓ Menu item: ${menuItems[i + j]['name']} (${batchRefs[j]})');
      }
    }

    return menuItemIds;
  }

  /// Seed reservations
  Future<List<String>> seedReservations(
    String customerId,
    List<String> menuItemIds,
  ) async {
    final now = DateTime.now();
    final reservations = [
      // Reservation 1: Pending
      {
        'customerId': customerId,
        'reservationDate': Timestamp.fromDate(
          now.add(const Duration(days: 1)).copyWith(hour: 18, minute: 0),
        ),
        'numberOfGuests': 2,
        'tableNumber': null,
        'status': 'pending',
        'specialRequests': 'Bàn gần cửa sổ',
        'orderItems': [],
        'subtotal': 0.0,
        'serviceCharge': 0.0,
        'discount': 0.0,
        'total': 0.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      // Reservation 2: Confirmed với order items
      {
        'customerId': customerId,
        'reservationDate': Timestamp.fromDate(
          now.add(const Duration(days: 2)).copyWith(hour: 19, minute: 30),
        ),
        'numberOfGuests': 4,
        'tableNumber': 'T05',
        'status': 'confirmed',
        'specialRequests': 'Yêu cầu bàn lớn',
        'orderItems': [
          {
            'itemId': menuItemIds[0], // Gỏi Cuốn
            'itemName': 'Gỏi Cuốn',
            'quantity': 2,
            'price': 35000.0,
            'subtotal': 70000.0,
          },
          {
            'itemId': menuItemIds[3], // Phở Bò
            'itemName': 'Phở Bò',
            'quantity': 2,
            'price': 50000.0,
            'subtotal': 100000.0,
          },
          {
            'itemId': menuItemIds[13], // Cà Phê Sữa Đá
            'itemName': 'Cà Phê Sữa Đá',
            'quantity': 2,
            'price': 25000.0,
            'subtotal': 50000.0,
          },
        ],
        'subtotal': 220000.0,
        'serviceCharge': 22000.0, // 10%
        'discount': 0.0,
        'total': 242000.0,
        'paymentMethod': null,
        'paymentStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      // Reservation 3: Completed
      {
        'customerId': customerId,
        'reservationDate': Timestamp.fromDate(
          now.subtract(const Duration(days: 1)).copyWith(hour: 12, minute: 0),
        ),
        'numberOfGuests': 3,
        'tableNumber': 'T12',
        'status': 'completed',
        'specialRequests': null,
        'orderItems': [
          {
            'itemId': menuItemIds[5], // Bún Bò Huế
            'itemName': 'Bún Bò Huế',
            'quantity': 3,
            'price': 55000.0,
            'subtotal': 165000.0,
          },
          {
            'itemId': menuItemIds[9], // Chè Đậu Xanh
            'itemName': 'Chè Đậu Xanh',
            'quantity': 3,
            'price': 20000.0,
            'subtotal': 60000.0,
          },
        ],
        'subtotal': 225000.0,
        'serviceCharge': 22500.0,
        'discount': 10000.0, // từ loyalty points
        'total': 237500.0,
        'paymentMethod': 'card',
        'paymentStatus': 'paid',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final List<String> reservationIds = [];
    
    // Sử dụng batch write
    final batch = _firestore.batch();
    final reservationRefs = <String>[];
    
    for (final reservationData in reservations) {
      final docRef = _firestore.collection('reservations').doc();
      reservationRefs.add(docRef.id);
      batch.set(docRef, reservationData);
    }
    
    await batch.commit();
    
    for (int i = 0; i < reservations.length; i++) {
      reservationIds.add(reservationRefs[i]);
      print('  ✓ Reservation: ${reservations[i]['status']} (${reservationRefs[i]})');
    }

    return reservationIds;
  }

  /// Xóa tất cả dữ liệu (cẩn thận!)
  /// Uncomment để sử dụng nếu cần
  // ignore: unused_element
  Future<void> _clearAllData() async {
    print('⚠️ Đang xóa dữ liệu cũ...');
    
    // Xóa reservations
    final reservations = await _firestore.collection('reservations').get();
    for (var doc in reservations.docs) {
      await doc.reference.delete();
    }

    // Xóa menu items
    final menuItems = await _firestore.collection('menu_items').get();
    for (var doc in menuItems.docs) {
      await doc.reference.delete();
    }

    // Xóa customers
    final customers = await _firestore.collection('customers').get();
    for (var doc in customers.docs) {
      await doc.reference.delete();
    }

    print('✓ Đã xóa dữ liệu cũ');
  }
}
