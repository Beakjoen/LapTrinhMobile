import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reservation.dart';
import '../models/order_item.dart';
import '../models/menu_item.dart';
import '../services/firestore_service.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numberOfGuests = 2;
  String? _specialRequests;
  final List<OrderItem> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn ngày giờ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn ngày và giờ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _selectDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _selectedDate == null
                                  ? 'Chọn ngày'
                                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _selectTime,
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              _selectedTime == null
                                  ? 'Chọn giờ'
                                  : _selectedTime!.format(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Số lượng khách
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Số lượng khách',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_numberOfGuests > 1) {
                              setState(() {
                                _numberOfGuests--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle),
                        ),
                        Text(
                          '$_numberOfGuests',
                          style: const TextStyle(fontSize: 24),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _numberOfGuests++;
                            });
                          },
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Chọn món ăn
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chọn món ăn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push<List<OrderItem>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuSelectionScreen(
                                  selectedItems: List.from(_selectedItems),
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                _selectedItems.clear();
                                _selectedItems.addAll(result);
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm món'),
                        ),
                      ],
                    ),
                    if (_selectedItems.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Chưa chọn món nào'),
                      )
                    else
                      ..._selectedItems.map((item) => ListTile(
                            title: Text(item.itemName),
                            subtitle: Text('${item.quantity} x ${item.price.toStringAsFixed(0)} đ'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${item.subtotal.toStringAsFixed(0)} đ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _selectedItems.remove(item);
                                    });
                                  },
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Yêu cầu đặc biệt
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yêu cầu đặc biệt (tùy chọn)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Nhập yêu cầu đặc biệt...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _specialRequests = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tổng tiền
            if (_selectedItems.isNotEmpty)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTotalRow('Tổng món', _calculateSubtotal()),
                      _buildTotalRow('Phí phục vụ (10%)', _calculateServiceCharge()),
                      _buildTotalRow('Giảm giá', 0.0),
                      const Divider(),
                      _buildTotalRow(
                        'Tổng cộng',
                        _calculateTotal(),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Nút đặt bàn
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit() ? _submitReservation : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Đặt bàn',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} đ',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    return _selectedItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double _calculateServiceCharge() {
    return _calculateSubtotal() * 0.1;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateServiceCharge();
  }

  bool _canSubmit() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _numberOfGuests > 0;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_canSubmit()) return;

    // TODO: Lấy customerId từ authentication
    const String customerId = 'customer_123'; // Thay bằng customerId thực tế

    final reservationDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final subtotal = _calculateSubtotal();
    final serviceCharge = _calculateServiceCharge();
    final total = subtotal + serviceCharge;

    final reservation = Reservation(
      reservationId: 'res_${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      reservationDate: reservationDate,
      numberOfGuests: _numberOfGuests,
      status: 'pending',
      specialRequests: _specialRequests,
      orderItems: _selectedItems,
      subtotal: subtotal,
      serviceCharge: serviceCharge,
      discount: 0.0,
      total: total,
      paymentStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _firestoreService.createReservation(reservation);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt bàn thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _numberOfGuests = 2;
          _specialRequests = null;
          _selectedItems.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Screen để chọn món ăn
class MenuSelectionScreen extends StatefulWidget {
  final List<OrderItem> selectedItems;

  const MenuSelectionScreen({
    super.key,
    required this.selectedItems,
  });

  @override
  State<MenuSelectionScreen> createState() => _MenuSelectionScreenState();
}

class _MenuSelectionScreenState extends State<MenuSelectionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final Map<String, int> _itemQuantities = {};

  @override
  void initState() {
    super.initState();
    // Khởi tạo quantities từ selectedItems
    for (var item in widget.selectedItems) {
      _itemQuantities[item.itemId] = item.quantity;
    }
  }

  void _updateQuantity(String itemId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _itemQuantities.remove(itemId);
      } else {
        _itemQuantities[itemId] = quantity;
      }
    });
  }

  List<OrderItem> _getSelectedItems(List<MenuItem> menuItems) {
    final List<OrderItem> result = [];
    for (var entry in _itemQuantities.entries) {
      final menuItem = menuItems.firstWhere(
        (item) => item.itemId == entry.key,
        orElse: () => menuItems.first,
      );
      result.add(OrderItem(
        itemId: menuItem.itemId,
        itemName: menuItem.name,
        quantity: entry.value,
        price: menuItem.price,
        subtotal: menuItem.price * entry.value,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn món ăn'),
        actions: [
          TextButton(
            onPressed: () {
              final selected = _getSelectedItems([]);
              Navigator.pop(context, selected);
            },
            child: const Text(
              'Xong',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: _firestoreService.getAllMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có món ăn nào'));
          }

          final menuItems = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final quantity = _itemQuantities[item.itemId] ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.price.toStringAsFixed(0)} đ'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _updateQuantity(item.itemId, quantity - 1);
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _updateQuantity(item.itemId, quantity + 1);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: StreamBuilder<List<MenuItem>>(
        stream: _firestoreService.getAllMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              onPressed: () {
                final selected = _getSelectedItems(snapshot.data!);
                Navigator.pop(context, selected);
              },
              label: const Text('Xong'),
              icon: const Icon(Icons.check),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
