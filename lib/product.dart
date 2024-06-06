class Product {
  String name;
  double price;
  int quantity;

  Product(this.name, this.price, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
class HistoryItem {
  final String name;
  final List<Product> products;

  HistoryItem(this.name, this.products);
}
