// Service class để thao tác với Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';
import '../models/menu_item.dart';
import '../models/reservation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== CUSTOMER OPERATIONS ==========

  // Tạo customer mới
  Future<String> createCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.customerId)
          .set(customer.toFirestore());
      return customer.customerId;
    } catch (e) {
      throw Exception('Lỗi tạo customer: $e');
    }
  }

  // Lấy customer theo ID
  Future<Customer?> getCustomerById(String customerId) async {
    try {
      final doc =
          await _firestore.collection('customers').doc(customerId).get();
      if (doc.exists) {
        return Customer.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi lấy customer: $e');
    }
  }

  // Lấy customer theo email
  Future<Customer?> getCustomerByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Customer.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi lấy customer: $e');
    }
  }

  // Cập nhật customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.customerId)
          .update(customer.toFirestore());
    } catch (e) {
      throw Exception('Lỗi cập nhật customer: $e');
    }
  }

  // Cập nhật loyalty points
  Future<void> updateLoyaltyPoints(String customerId, int points) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customerId)
          .update({'loyaltyPoints': FieldValue.increment(points)});
    } catch (e) {
      throw Exception('Lỗi cập nhật loyalty points: $e');
    }
  }

  // ========== MENU ITEM OPERATIONS ==========

  // Lấy tất cả menu items
  Stream<List<MenuItem>> getAllMenuItems() {
    return _firestore
        .collection('menu_items')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList());
  }

  // Lấy menu items theo category
  Stream<List<MenuItem>> getMenuItemsByCategory(String category) {
    return _firestore
        .collection('menu_items')
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList());
  }

  // Lấy menu item theo ID
  Future<MenuItem?> getMenuItemById(String itemId) async {
    try {
      final doc = await _firestore.collection('menu_items').doc(itemId).get();
      if (doc.exists) {
        return MenuItem.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi lấy menu item: $e');
    }
  }

  // Tạo menu item mới
  Future<String> createMenuItem(MenuItem item) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(item.itemId)
          .set(item.toFirestore());
      return item.itemId;
    } catch (e) {
      throw Exception('Lỗi tạo menu item: $e');
    }
  }

  // Cập nhật menu item
  Future<void> updateMenuItem(MenuItem item) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(item.itemId)
          .update(item.toFirestore());
    } catch (e) {
      throw Exception('Lỗi cập nhật menu item: $e');
    }
  }

  // Xóa menu item
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _firestore.collection('menu_items').doc(itemId).delete();
    } catch (e) {
      throw Exception('Lỗi xóa menu item: $e');
    }
  }

  // Lấy tất cả menu items (bao gồm cả unavailable) - cho admin
  Stream<List<MenuItem>> getAllMenuItemsForAdmin() {
    return _firestore.collection('menu_items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => MenuItem.fromFirestore(doc)).toList());
  }

  // ========== RESERVATION OPERATIONS ==========

  // Tạo reservation mới
  Future<String> createReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection('reservations')
          .doc(reservation.reservationId)
          .set(reservation.toFirestore());
      return reservation.reservationId;
    } catch (e) {
      throw Exception('Lỗi tạo reservation: $e');
    }
  }

  // Lấy reservations của customer
  Stream<List<Reservation>> getCustomerReservations(String customerId) {
    return _firestore
        .collection('reservations')
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromFirestore(doc))
            .toList());
  }

  // Lấy reservation theo ID
  Future<Reservation?> getReservationById(String reservationId) async {
    try {
      final doc =
          await _firestore.collection('reservations').doc(reservationId).get();
      if (doc.exists) {
        return Reservation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Lỗi lấy reservation: $e');
    }
  }

  // Cập nhật reservation
  Future<void> updateReservation(Reservation reservation) async {
    try {
      await _firestore
          .collection('reservations')
          .doc(reservation.reservationId)
          .update(reservation.toFirestore());
    } catch (e) {
      throw Exception('Lỗi cập nhật reservation: $e');
    }
  }

  // Xác nhận reservation (set status = "confirmed" và phân tableNumber)
  Future<void> confirmReservation(
      String reservationId, String tableNumber) async {
    try {
      await _firestore.collection('reservations').doc(reservationId).update({
        'status': 'confirmed',
        'tableNumber': tableNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Lỗi xác nhận reservation: $e');
    }
  }

  // Thanh toán reservation (tính loyaltyPoints và cập nhật paymentStatus)
  Future<void> payReservation(String reservationId, String paymentMethod,
      String customerId, double total) async {
    try {
      // Cập nhật reservation
      await _firestore.collection('reservations').doc(reservationId).update({
        'paymentStatus': 'paid',
        'paymentMethod': paymentMethod,
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Tính loyaltyPoints (1% total) và cộng vào customer
      int loyaltyPoints = (total * 0.01).round();
      await updateLoyaltyPoints(customerId, loyaltyPoints);
    } catch (e) {
      throw Exception('Lỗi thanh toán: $e');
    }
  }

  // Lấy tất cả reservations (cho admin)
  Stream<List<Reservation>> getAllReservations() {
    return _firestore
        .collection('reservations')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reservation.fromFirestore(doc))
            .toList());
  }
}
