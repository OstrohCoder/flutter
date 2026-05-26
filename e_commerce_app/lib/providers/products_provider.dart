import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

/// TODO: Створіть Provider для списку продуктів
///
/// Provider - це найпростіший тип провайдера у Riverpod.
/// Використовується для незмінних даних (immutable data).
///
/// Приклад:
/// final myProvider = Provider<List<Product>>((ref) {
///   return [/* список продуктів */];
/// });

final productsProvider = Provider<List<Product>>((ref) {
  // TODO: Поверніть список з 5-6 продуктів
  // Використовуйте емодзі для зображень: 📱, 💻, ⌚, 🎧, 📷, 🖥️

  return const [
    Product(
      id: '1',
      name: 'Flutter Smartphone',
      price: 999.99,
      category: 'Electronics',
      imageEmoji: '📱',
    ),
    Product(
      id: '2',
      name: 'Developer Hoodie',
      price: 59.99,
      category: 'Clothing',
      imageEmoji: '🧥',
    ),
    Product(
      id: '3',
      name: '"Flutter in Action"',
      price: 45.00,
      category: 'Books',
      imageEmoji: '📚',
    ),
    Product(
      id: '4',
      name: 'MacBook Pro 16',
      price: 2499.99,
      category: 'Electronics',
      imageEmoji: '💻',
    ),
    Product(
      id: '5',
      name: 'Coding Cap',
      price: 24.99,
      category: 'Clothing',
      imageEmoji: '🧢',
    ),
  ];
});

/// TODO (додатково): Створіть computed provider для загальної вартості всіх продуктів
///
/// Приклад:
/// final totalPriceProvider = Provider<double>((ref) {
///   final products = ref.watch(productsProvider);
///   return products.fold(0.0, (sum, product) => sum + product.price);
/// });
