// Model class cho MenuItem
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String itemId;
  final String name;
  final String description;
  final String category; // "Appetizer", "Main Course", "Dessert", "Beverage", "Soup"
  final double price;
  final String imageUrl;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isSpicy;
  final int preparationTime; // phút
  final bool isAvailable;
  final double rating; // 0.0 - 5.0
  final DateTime createdAt;

  MenuItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
    this.isVegetarian = false,
    this.isSpicy = false,
    required this.preparationTime,
    this.isAvailable = true,
    this.rating = 0.0,
    required this.createdAt,
  });

  // Convert từ Firestore Document
  factory MenuItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuItem(
      itemId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isVegetarian: data['isVegetarian'] ?? false,
      isSpicy: data['isSpicy'] ?? false,
      preparationTime: data['preparationTime'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method
  MenuItem copyWith({
    String? itemId,
    String? name,
    String? description,
    String? category,
    double? price,
    String? imageUrl,
    List<String>? ingredients,
    bool? isVegetarian,
    bool? isSpicy,
    int? preparationTime,
    bool? isAvailable,
    double? rating,
    DateTime? createdAt,
  }) {
    return MenuItem(
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isSpicy: isSpicy ?? this.isSpicy,
      preparationTime: preparationTime ?? this.preparationTime,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
