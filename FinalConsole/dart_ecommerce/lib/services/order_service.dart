import 'package:collection/collection.dart';

import '../models/order.dart';
import '../models/product.dart';

class OrderService {
  final List<Order> _orders = [];

  void createOrder(String id, Map<Product, int> productsWithQuantities) {
    _orders.add(Order(id, productsWithQuantities));
  }

  void updateOrder(String id, Map<Product, int> productsWithQuantities) {
    final orderIndex = _orders.indexWhere((order) => order.id == id);
    if (orderIndex != -1) {
      _orders[orderIndex] = Order(id, productsWithQuantities);
    }
  }

  List<Order> getOrders() => List.unmodifiable(_orders);

  Order? getOrderById(String id) {
    return _orders.firstWhereOrNull((order) => order.id == id);
  }
}
