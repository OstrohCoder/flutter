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
      price: 1000.00,
      category: 'Electronics',
      imageEmoji: '📱',
    ),
    Product(
      id: '2',
      name: 'Developer Hoodie',
      price: 60.00,
      category: 'Clothing',
      imageEmoji: '🧥',
    ),
    Product(
      id: '3',
      name: '"Flutter in Action"',
      price: 45.50,
      category: 'Books',
      imageEmoji: '📚',
    ),
    Product(
      id: '4',
      name: 'MacBook Pro 16',
      price: 2400.00,
      category: 'Electronics',
      imageEmoji: '💻',
    ),
    Product(
      id: '5',
      name: 'Coding Cap',
      price: 25.50,
      category: 'Clothing',
      imageEmoji: '🧢',
    ),
  ];
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return products.where((p) {
    final matchesCategory =
        selectedCategory == null || p.category == selectedCategory;
    final matchesQuery = query.isEmpty || p.name.toLowerCase().contains(query);
    return matchesCategory && matchesQuery;
  }).toList();
});

/// TODO (додатково): Створіть computed provider для загальної вартості всіх продуктів
///
/// Приклад:
/// final totalPriceProvider = Provider<double>((ref) {
///   final products = ref.watch(productsProvider);
///   return products.fold(0.0, (sum, product) => sum + product.price);
/// });
