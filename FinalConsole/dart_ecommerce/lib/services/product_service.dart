import 'package:collection/collection.dart';
import '../models/product.dart';

class ProductService {
  final List<Product> _products = [
    Product('1', 'MacPro', 29999.99),
    Product('2', 'Asus Vivabook', 29999.99),
    Product('3', 'ACER PREDATOR ORION 7000 ', 200095.00),
    Product('4', 'LENOVO IdeaPad Gaming 3', 44995.00),
    Product('5', 'ACER Nitro V ANV15-51-53DG', 53199.00),
  ];

  List<Product> getProducts() => List.unmodifiable(_products);

  Product? getProductById(String id) {
    return _products.firstWhereOrNull((product) => product.id == id);
  }
}
