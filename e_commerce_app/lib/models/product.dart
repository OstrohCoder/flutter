/// Модель продукту для E-commerce додатку
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageEmoji;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageEmoji,
  });

  // Копіювання об'єкта з можливістю зміни окремих полів
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? imageEmoji,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imageEmoji: imageEmoji ?? this.imageEmoji,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: \$$price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
