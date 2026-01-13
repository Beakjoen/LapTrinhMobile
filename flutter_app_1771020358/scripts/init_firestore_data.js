/**
 * Script để thêm dữ liệu mẫu vào Firestore
 * 
 * CÁCH SỬ DỤNG:
 * 1. Mở Firebase Console > Firestore Database
 * 2. Mở Developer Tools (F12)
 * 3. Vào tab Console
 * 4. Copy và paste toàn bộ code này vào Console
 * 5. Nhấn Enter để chạy
 * 
 * HOẶC:
 * 1. Tạo file HTML đơn giản với Firebase SDK
 * 2. Mở file HTML trong browser
 * 3. Script sẽ tự động chạy
 */

// ⚠️ LƯU Ý: Cần thay thế firebaseConfig bằng config của bạn
// Lấy từ Firebase Console > Project Settings > General > Your apps > Web app

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

// Khởi tạo Firebase (nếu chưa có)
if (typeof firebase === 'undefined') {
  console.error('Firebase SDK chưa được load. Vui lòng thêm script tag:');
  console.log('<script src="https://www.gstatic.com/firebasejs/9.6.0/firebase-app-compat.js"></script>');
  console.log('<script src="https://www.gstatic.com/firebasejs/9.6.0/firebase-firestore-compat.js"></script>');
}

// Khởi tạo Firestore
const db = firebase.firestore();

// Hàm thêm dữ liệu mẫu
async function initFirestoreData() {
  try {
    console.log('Bắt đầu thêm dữ liệu mẫu...');

    // 1. Thêm Customers
    const customers = [
      {
        email: "customer1@example.com",
        fullName: "Nguyễn Văn A",
        phoneNumber: "0123456789",
        address: "123 Đường ABC, Quận 1, TP.HCM",
        preferences: ["vegetarian", "spicy"],
        loyaltyPoints: 0,
        createdAt: firebase.firestore.FieldValue.serverTimestamp(),
        isActive: true
      },
      {
        email: "customer2@example.com",
        fullName: "Trần Thị B",
        phoneNumber: "0987654321",
        address: "456 Đường XYZ, Quận 2, TP.HCM",
        preferences: ["seafood"],
        loyaltyPoints: 500,
        createdAt: firebase.firestore.FieldValue.serverTimestamp(),
        isActive: true
      }
    ];

    console.log('Đang thêm customers...');
    for (const customer of customers) {
      const docRef = await db.collection('customers').add(customer);
      console.log(`✅ Đã thêm customer: ${docRef.id}`);
    }

    // 2. Thêm Menu Items
    const menuItems = [
      {
        name: "Phở Bò",
        description: "Phở bò truyền thống Việt Nam với nước dùng đậm đà",
        category: "Main Course",
        price: 50000,
        imageUrl: "",
        ingredients: ["bánh phở", "thịt bò", "hành", "rau thơm", "chanh", "ớt"],
        isVegetarian: false,
        isSpicy: false,
        preparationTime: 15,
        isAvailable: true,
        rating: 4.5,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Phở Gà",
        description: "Phở gà thơm ngon, nước dùng trong",
        category: "Main Course",
        price: 45000,
        imageUrl: "",
        ingredients: ["bánh phở", "thịt gà", "hành", "rau thơm"],
        isVegetarian: false,
        isSpicy: false,
        preparationTime: 12,
        isAvailable: true,
        rating: 4.3,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Gỏi Cuốn",
        description: "Gỏi cuốn tôm thịt tươi ngon",
        category: "Appetizer",
        price: 35000,
        imageUrl: "",
        ingredients: ["bánh tráng", "tôm", "thịt", "rau sống", "bún"],
        isVegetarian: false,
        isSpicy: false,
        preparationTime: 10,
        isAvailable: true,
        rating: 4.7,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Bún Bò Huế",
        description: "Bún bò Huế cay nồng đậm đà",
        category: "Main Course",
        price: 55000,
        imageUrl: "",
        ingredients: ["bún", "thịt bò", "chả", "rau thơm", "ớt"],
        isVegetarian: false,
        isSpicy: true,
        preparationTime: 20,
        isAvailable: true,
        rating: 4.8,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Chè Đậu Xanh",
        description: "Chè đậu xanh mát lạnh",
        category: "Dessert",
        price: 20000,
        imageUrl: "",
        ingredients: ["đậu xanh", "đường", "dừa", "đá"],
        isVegetarian: true,
        isSpicy: false,
        preparationTime: 5,
        isAvailable: true,
        rating: 4.2,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Cà Phê Sữa Đá",
        description: "Cà phê sữa đá đậm đà phong cách Việt Nam",
        category: "Beverage",
        price: 25000,
        imageUrl: "",
        ingredients: ["cà phê", "sữa đặc", "đá"],
        isVegetarian: true,
        isSpicy: false,
        preparationTime: 3,
        isAvailable: true,
        rating: 4.6,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      },
      {
        name: "Canh Chua Cá",
        description: "Canh chua cá lóc chua ngọt",
        category: "Soup",
        price: 60000,
        imageUrl: "",
        ingredients: ["cá lóc", "cà chua", "dứa", "đậu bắp", "rau thơm"],
        isVegetarian: false,
        isSpicy: false,
        preparationTime: 25,
        isAvailable: true,
        rating: 4.4,
        createdAt: firebase.firestore.FieldValue.serverTimestamp()
      }
    ];

    console.log('Đang thêm menu items...');
    for (const item of menuItems) {
      const docRef = await db.collection('menu_items').add(item);
      console.log(`✅ Đã thêm menu item: ${item.name} (${docRef.id})`);
    }

    // 3. Lấy customerId đầu tiên để tạo reservation
    const customersSnapshot = await db.collection('customers').limit(1).get();
    if (customersSnapshot.empty) {
      console.warn('⚠️ Không có customer nào. Bỏ qua việc tạo reservation.');
      return;
    }

    const customerId = customersSnapshot.docs[0].id;
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(18, 0, 0, 0); // 6 PM ngày mai

    // 4. Thêm Reservation mẫu
    const reservation = {
      customerId: customerId,
      reservationDate: firebase.firestore.Timestamp.fromDate(tomorrow),
      numberOfGuests: 2,
      tableNumber: null,
      status: "pending",
      specialRequests: "Bàn gần cửa sổ",
      orderItems: [],
      serviceCharge: 0,
      discount: 0,
      total: 0,
      paymentMethod: null,
      paymentStatus: "pending",
      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
    };

    console.log('Đang thêm reservation...');
    const reservationRef = await db.collection('reservations').add(reservation);
    console.log(`✅ Đã thêm reservation: ${reservationRef.id}`);

    console.log('\n🎉 Hoàn thành! Đã thêm dữ liệu mẫu vào Firestore.');
    console.log(`- ${customers.length} customers`);
    console.log(`- ${menuItems.length} menu items`);
    console.log('- 1 reservation');

  } catch (error) {
    console.error('❌ Lỗi:', error);
  }
}

// Chạy script
initFirestoreData();
