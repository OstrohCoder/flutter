import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  Map<String, dynamic> toJson() => {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'category': product.category,
        'imageEmoji': product.imageEmoji,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product(
          id: json['id'],
          name: json['name'],
          price: json['price'],
          category: json['category'],
          imageEmoji: json['imageEmoji'],
        ),
        quantity: json['quantity'],
      );
}

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

class CartNotifier extends StateNotifier<List<CartItem>> {
  static const _key = 'cart_items';

  CartNotifier() : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  /// TODO: Реалізуйте метод додавання продукту в кошик
  void addProduct(Product product) {
    // ПІДКАЗКА: state = [...state, product];
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final updated = List<CartItem>.from(state);
      updated[index] =
          state[index].copyWith(quantity: state[index].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }

    _saveToPrefs();
  }

  /// TODO: Реалізуйте метод видалення продукту з кошика
  void removeProduct(String productId) {
    // ПІДКАЗКА: Використайте where() для фільтрації
    state = state.where((item) => item.product.id != productId).toList();
    _saveToPrefs();
  }

  void increment(String productId) {
    state = state
        .map((item) => item.product.id == productId
            ? item.copyWith(quantity: item.quantity + 1)
            : item)
        .toList();
    _saveToPrefs();
  }

  void decrement(String productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    if (item.quantity <= 1) {
      removeProduct(productId);
    } else {
      state = state
          .map((i) => i.product.id == productId
              ? i.copyWith(quantity: i.quantity - 1)
              : i)
          .toList();
      _saveToPrefs();
    }
  }

  /// TODO: Реалізуйте метод очищення кошика
  void clearCart() {
    state = [];
    _saveToPrefs();
  }

  /// Перевірка чи продукт вже в кошику
  bool isInCart(String productId) {
    return state.any((item) => item.product.id == productId);
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

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
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
  return cartItems.fold(
      0.0, (sum, item) => sum + item.product.price * item.quantity);
});

/// Computed provider для кількості товарів у кошику
final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});
