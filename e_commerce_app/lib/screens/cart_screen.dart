import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

/// TODO: Змініть StatelessWidget на ConsumerWidget
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Прочитайте список товарів у кошику
    final cartItems = ref.watch(cartProvider);

    // TODO: Прочитайте загальну вартість кошика
    final totalPrice = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          // TODO: Додайте кнопку "Clear Cart"
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear Cart',
              onPressed: () {
                // Показуємо діалог підтвердження
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text(
                      'Are you sure you want to remove all items from the cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearCart();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cart cleared'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartList(context, ref, cartItems),
      bottomNavigationBar:
          cartItems.isNotEmpty ? _buildBottomBar(context, totalPrice) : null,
    );
  }

  /// Порожній кошик
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  /// Список товарів у кошику
  Widget _buildCartList(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> cartItems,
  ) {
    return ListView.builder(
      itemCount: cartItems.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final product = item.product;

        return Dismissible(
          key: Key(product.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            ref.read(cartProvider.notifier).removeProduct(product.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${product.name} removed from cart'),
                  duration: const Duration(seconds: 1)),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              // TODO: Додайте емодзі продукту
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade100,
                child: Text(product.imageEmoji,
                    style: const TextStyle(fontSize: 28)),
              ),
              // TODO: Додайте назву та ціну
              title: Text(
                '${product.name} x${item.quantity}', // <-- "x2"
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '\$${(product.price * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TODO: Додайте кнопку видалення
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                    onPressed: () =>
                        ref.read(cartProvider.notifier).decrement(product.id),
                  ),
                  Text('${item.quantity}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.green),
                    onPressed: () =>
                        ref.read(cartProvider.notifier).increment(product.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Нижня панель з загальною вартістю
  Widget _buildBottomBar(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TODO: Покажіть загальну вартість
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            // TODO: Додайте кнопку "Checkout"
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Реалізуйте checkout логіку
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Checkout'),
                    content: Text(
                      'Total amount: \$${totalPrice.toStringAsFixed(2)}\n\n'
                      'This is a demo. Checkout functionality will be implemented later.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Checkout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
