// Constants cho ứng dụng
class AppConstants {
  // Firestore Collections
  static const String customersCollection = 'customers';
  static const String menuItemsCollection = 'menu_items';
  static const String reservationsCollection = 'reservations';

  // Reservation Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusSeated = 'seated';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  static const String statusNoShow = 'no_show';

  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentPaid = 'paid';
  static const String paymentRefunded = 'refunded';

  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentCard = 'card';
  static const String paymentOnline = 'online';

  // Menu Categories
  static const String categoryAppetizer = 'Appetizer';
  static const String categoryMainCourse = 'Main Course';
  static const String categoryDessert = 'Dessert';
  static const String categoryBeverage = 'Beverage';
  static const String categorySoup = 'Soup';

  // Service Charge Percentage
  static const double serviceChargePercent = 0.1; // 10%

  // Loyalty Points Rate
  static const double loyaltyPointsRate = 0.01; // 1% of total
}
