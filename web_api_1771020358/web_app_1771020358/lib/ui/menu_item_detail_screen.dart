import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

class MenuItemDetailScreen extends StatelessWidget {
  final MenuItem item;

  const MenuItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                ),
              ),
              background: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300]),
                    )
                  : Container(color: Colors.grey[300]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price.toStringAsFixed(0)} đ',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Chip(
                        label: Text(item.category),
                        backgroundColor: Colors.deepPurple.shade50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (item.isVegetarian)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.eco, size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                'Món chay',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      if (item.isSpicy)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.whatshot, size: 16, color: Colors.red),
                              SizedBox(width: 4),
                              Text(
                                'Cay',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mô tả',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (item.preparationTime != null) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Thời gian chuẩn bị: ${item.preparationTime} phút',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
