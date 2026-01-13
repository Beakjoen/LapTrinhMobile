import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseInitialized = false;
  String? errorMessage;
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
    debugPrint('Firebase initialized successfully');
  } catch (e, stackTrace) {
    errorMessage = 'Firebase initialization error: $e';
    debugPrint(errorMessage);
    debugPrint('Stack trace: $stackTrace');
  }
  
  runApp(MyApp(
    firebaseInitialized: firebaseInitialized,
    errorMessage: errorMessage,
  ));
}

class MyApp extends StatelessWidget {
  final bool firebaseInitialized;
  final String? errorMessage;

  const MyApp({
    super.key,
    required this.firebaseInitialized,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Nhà hàng',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: firebaseInitialized
          ? const HomeScreen()
          : ErrorScreen(errorMessage: errorMessage),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;

  const ErrorScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lỗi khởi tạo'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Không thể khởi tạo Firebase',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              const Text(
                'Vui lòng kiểm tra:\n'
                '1. Console (F12) để xem lỗi chi tiết\n'
                '2. Firebase configuration trong firebase_options.dart\n'
                '3. Đảm bảo đã thêm Web app trong Firebase Console',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
