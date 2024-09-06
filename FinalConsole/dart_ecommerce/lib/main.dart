import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'models/product.dart';
import 'services/order_service.dart';
import 'services/product_service.dart';
import 'services/user_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

void main() {
  final container = ProviderContainer();
  final productService = container.read(productServiceProvider);
  final orderService = container.read(orderServiceProvider);
  final userService = container.read(userServiceProvider);

  if (!login(userService)) {
    print('Login failed. Exiting...');
    exit(1);
  }

  while (true) {
    print('Dashboard:');
    print('1. Products');
    print('2. Create Order');
    print('3. Update Order');
    print('4. Orders');
    print('5. Logout');

    stdout.write('Enter Input: ');
    String? choice = stdin.readLineSync();
    print('User input received: $choice');

    switch (choice) {
      case '1':
        listProducts(productService);
        break;
      case '2':
        createOrder(productService, orderService);
        break;
      case '3':
        updateOrder(productService, orderService);
        break;
      case '4':
        listOrders(orderService);
        break;
      case '5':
        exit(0);
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

bool login(UserService userService) {
  print('Login');
  stdout.write('Enter username: ');
  String? username = stdin.readLineSync()?.trim();

  stdout.write('Enter password: ');
  String? password = stdin.readLineSync()?.trim();

  if (username != null && password != null) {
    if (userService.authenticate(username, password)) {
      print('Login successful!');
      return true;
    } else {
      print('Invalid username or password.');
      return false;
    }
  } else {
    print('Username or password cannot be empty.');
    return false;
  }
}

void listProducts(ProductService productService) {
  print('Available products:');
  for (var product in productService.getProducts()) {
    print('${product.id}: ${product.name} - \₱${product.price}');
  }
}

void createOrder(ProductService productService, OrderService orderService) {
  print('Enter Order ID:');
  String? orderId = stdin.readLineSync()?.trim();
  if (orderId == null || orderId.isEmpty) {
    print('Invalid Order ID.');
    return;
  }

  print(
      'Enter product IDs and quantities (format: productId:quantity, e.g., 1:2,2:1):');
  String? input = stdin.readLineSync()?.trim();
  if (input == null || input.isEmpty) {
    print('No products selected.');
    return;
  }

  Map<Product, int> productsWithQuantities = {};
  for (var entry in input.split(',')) {
    var parts = entry.split(':');
    if (parts.length == 2) {
      var productId = parts[0].trim();
      var quantityStr = parts[1].trim();
      var product = productService.getProductById(productId);
      if (product != null) {
        var quantity = int.tryParse(quantityStr);
        if (quantity != null && quantity > 0) {
          productsWithQuantities[product] = quantity;
        } else {
          print('Invalid quantity for product with ID $productId.');
        }
      } else {
        print('Product with ID $productId not found.');
      }
    } else {
      print('Invalid format for entry: $entry');
    }
  }

  if (productsWithQuantities.isNotEmpty) {
    orderService.createOrder(orderId, productsWithQuantities);
    print('Order created with ID $orderId.');
  } else {
    print('No valid products and quantities were entered.');
  }
}

void updateOrder(ProductService productService, OrderService orderService) {
  print('Enter Order ID to update:');
  String? orderId = stdin.readLineSync()?.trim();
  if (orderId == null || orderId.isEmpty) {
    print('Invalid Order ID.');
    return;
  }

  var existingOrder = orderService.getOrderById(orderId);
  if (existingOrder == null) {
    print('Order with ID $orderId not found.');
    return;
  }

  print(
      'Enter new product IDs and quantities (format: productId:quantity, e.g., 1:2,2:1):');
  String? input = stdin.readLineSync()?.trim();
  if (input == null || input.isEmpty) {
    print('No products selected.');
    return;
  }

  Map<Product, int> productsWithQuantities = {};
  for (var entry in input.split(',')) {
    var parts = entry.split(':');
    if (parts.length == 2) {
      var productId = parts[0].trim();
      var quantityStr = parts[1].trim();
      var product = productService.getProductById(productId);
      if (product != null) {
        var quantity = int.tryParse(quantityStr);
        if (quantity != null && quantity > 0) {
          productsWithQuantities[product] = quantity;
        } else {
          print('Invalid quantity for product with ID $productId.');
        }
      } else {
        print('Product with ID $productId not found.');
      }
    } else {
      print('Invalid format for entry: $entry');
    }
  }

  if (productsWithQuantities.isNotEmpty) {
    orderService.updateOrder(orderId, productsWithQuantities);
    print('Order with ID $orderId updated.');
  } else {
    print('No valid products and quantities were entered.');
  }
}

void listOrders(OrderService orderService) {
  print('Orders:');
  for (var order in orderService.getOrders()) {
    print('Order ID: ${order.id}');
    for (var entry in order.productsWithQuantities.entries) {
      var product = entry.key;
      var quantity = entry.value;
      print('  Product: ${product.name} - ₱${product.price} x $quantity');
    }
    print('  Final Price: ₱${order.finalPrice}');
  }
}
