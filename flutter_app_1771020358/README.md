# Flutter App Quản lý Nhà hàng - Bài Kiểm Tra 1

## Thông tin Project
- **Tên project**: flutter_app_1771020358
- **Package name**: com.example.app1771020358
- **Mô tả**: Ứng dụng Flutter quản lý nhà hàng với Firebase Firestore

## 📚 Tài liệu

- **[HUONG_DAN_CAI_DAT.md](./HUONG_DAN_CAI_DAT.md)** - Hướng dẫn cài đặt và chạy project
- **[HUONG_DAN_FIRESTORE.md](./HUONG_DAN_FIRESTORE.md)** - Hướng dẫn thiết lập Firestore Database (KHÔNG CẦN MySQL!)
- **[CAU_TRUC_PROJECT.md](./CAU_TRUC_PROJECT.md)** - Cấu trúc project
- **[TODO.md](./TODO.md)** - Danh sách công việc cần hoàn thiện

## Cấu trúc Project

```
lib/
├── main.dart                    # Entry point
├── models/                      # Model classes
│   ├── customer.dart
│   ├── menu_item.dart
│   ├── order_item.dart
│   └── reservation.dart
├── services/                    # Service classes
│   └── firestore_service.dart
└── screens/                     # UI Screens
    ├── home_screen.dart
    ├── menu_screen.dart
    ├── reservation_screen.dart
    └── my_reservations_screen.dart
```

## ⚡ Quick Start

### 1. Cài đặt dependencies
```bash
cd flutter_app_1771020358
flutter pub get
```

### 2. Thiết lập Firebase

**⚠️ QUAN TRỌNG: Firestore KHÔNG CẦN MySQL Server!**

1. Tạo Firebase project tại https://console.firebase.google.com
2. Thêm Android app với package name: `com.example.app1771020358`
3. Download `google-services.json` và đặt vào `android/app/`
4. Tạo Firestore Database (xem [HUONG_DAN_FIRESTORE.md](./HUONG_DAN_FIRESTORE.md))
5. Thêm dữ liệu mẫu bằng `scripts/init_firestore_data.html`

### 3. Chạy ứng dụng
```bash
flutter run
```

## 🗄️ Firestore Database

### Collections

1. **customers** - Thông tin khách hàng
2. **menu_items** - Danh sách món ăn
3. **reservations** - Đặt bàn và đơn hàng

Xem chi tiết cấu trúc tại [HUONG_DAN_FIRESTORE.md](./HUONG_DAN_FIRESTORE.md)

## Chức năng

### Phần 1: Thiết lập Firebase (10 điểm)
- ✅ Cài đặt Firebase trong Flutter
- ✅ Tạo Firestore Database
- ✅ Tạo Service Class

### Phần 2: Model Classes (15 điểm)
- ✅ Customer model
- ✅ MenuItem model
- ✅ Reservation model
- ✅ OrderItem model

### Phần 3: UI Screens
- ✅ Menu Screen - Xem danh sách món ăn
- ✅ Reservation Screen - Đặt bàn và chọn món
- ✅ My Reservations Screen - Xem lịch sử đặt bàn

## 🔧 Troubleshooting

### Lỗi "google-services.json not found"
- Kiểm tra file có đúng vị trí `android/app/google-services.json`
- Clean và rebuild: `flutter clean && flutter pub get`

### Lỗi "Firebase not initialized"
- Kiểm tra `main.dart` có `await Firebase.initializeApp()`
- Kiểm tra dependencies trong `pubspec.yaml`

### Lỗi "Permission denied" trong Firestore
- Kiểm tra Firestore Security Rules
- Đảm bảo đã chọn Test mode hoặc cấu hình rules đúng

### Không thấy Firestore Database
- Đảm bảo đã tạo database và chọn location
- Refresh trang Firebase Console

## 📝 Lưu ý

1. **Customer ID**: Hiện tại code sử dụng hardcode. Cần tích hợp Firebase Authentication để lấy customerId thực tế.

2. **Firebase Config**: Có thể sử dụng FlutterFire CLI:
```bash
flutterfire configure
```

3. **Security Rules**: Cần cấu hình Firestore Security Rules phù hợp cho production.

## 📞 Hỗ trợ

Nếu gặp vấn đề, xem các file hướng dẫn:
- [HUONG_DAN_CAI_DAT.md](./HUONG_DAN_CAI_DAT.md)
- [HUONG_DAN_FIRESTORE.md](./HUONG_DAN_FIRESTORE.md)
