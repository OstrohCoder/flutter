import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

/// TODO: Створіть StateNotifier для управління кошиком
///
/// StateNotifier<T> - це клас для управління змінним станом (mutable state).
/// Використовується коли потрібно оновлювати дані (add, remove, clear).
///
/// Приклад структури:
///
/// class CartNotifier extends StateNotifier<List<Product>> {
///   CartNotifier() : super([]);  // Початковий стан - порожній список
///
///   void addProduct(Product product) {
///     state = [...state, product];  // Створюємо новий список
///   }
///
///   void removeProduct(String productId) {
///     state = state.where((p) => p.id != productId).toList();
///   }
///
///   void clearCart() {
///     state = [];
///   }
/// }

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  /// TODO: Реалізуйте метод додавання продукту в кошик
  void addProduct(Product product) {
    // ПІДКАЗКА: state = [...state, product];
    state = [...state, product];
  }

  /// TODO: Реалізуйте метод видалення продукту з кошика
  void removeProduct(String productId) {
    // ПІДКАЗКА: Використайте where() для фільтрації
    state = state.where((product) => product.id != productId).toList();
  }

  /// TODO: Реалізуйте метод очищення кошика
  void clearCart() {
    state = [];
  }

  /// Перевірка чи продукт вже в кошику
  bool isInCart(String productId) {
    return state.any((product) => product.id == productId);
  }

  /// Кількість певного продукту в кошику
  int getProductCount(String productId) {
    return state.where((product) => product.id == productId).length;
  }
}

/// TODO: Створіть StateNotifierProvider для CartNotifier
///
/// StateNotifierProvider дозволяє віджетам читати та змінювати стан.
///
/// Приклад:
/// final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
///   return CartNotifier();
/// });

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});

/// TODO: Створіть computed provider для підрахунку загальної вартості кошика
///
/// Provider може залежати від іншого provider через ref.watch()
///
/// Приклад:
/// final cartTotalProvider = Provider<double>((ref) {
///   final cartItems = ref.watch(cartProvider);
///   return cartItems.fold(0.0, (sum, product) => sum + product.price);
/// });

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (sum, product) => sum + product.price);
});

/// Computed provider для кількості товарів у кошику
final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.length;
});
