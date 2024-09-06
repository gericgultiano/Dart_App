import 'product.dart';

class Order {
  final String id;
  final Map<Product, int>
      productsWithQuantities; // Map to store products and their quantities

  double finalPrice;

  Order(this.id, this.productsWithQuantities)
      : finalPrice = productsWithQuantities.entries
            .fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));
}
