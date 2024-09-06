import 'package:riverpod/riverpod.dart';

import 'order_service.dart';
import 'product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});
