class MenuItem {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? imageUrl;
  final int? preparationTime;
  final bool isVegetarian;
  final bool isSpicy;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    this.preparationTime,
    required this.isVegetarian,
    required this.isSpicy,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'],
      preparationTime: json['preparation_time'],
      isVegetarian: json['is_vegetarian'] ?? false,
      isSpicy: json['is_spicy'] ?? false,
      isAvailable: json['is_available'] ?? true,
    );
  }
}
