import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

/// TODO: Змініть StatelessWidget на ConsumerWidget
///
/// ConsumerWidget - це Riverpod версія StatelessWidget.
/// Надає доступ до WidgetRef через параметр build методу.
///
/// Приклад:
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final data = ref.watch(myProvider);
///     return Text(data);
///   }
/// }

class ProductsScreen extends ConsumerWidget {
  final _searchController = TextEditingController();
  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Прочитайте список продуктів з productsProvider
    // Використайте: ref.watch(productsProvider)
    final products = ref.watch(filteredProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final allProducts = ref.watch(productsProvider);
    final categories = allProducts.map((p) => p.category).toSet().toList();
    final searchQuery = ref.watch(searchQueryProvider);

    // TODO: Прочитайте кількість товарів у кошику для badge
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          centerTitle: true,
          actions: [
            // TODO: Додайте іконку кошика з badge
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                ),
                // Badge з кількістю товарів
                if (cartItemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(children: [
          // Фільтр по категоріях
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == null,
                  onSelected: (_) =>
                      ref.read(selectedCategoryProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                ...categories.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: selectedCategory == cat,
                        onSelected: (_) => ref
                            .read(selectedCategoryProvider.notifier)
                            .state = cat,
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final product = products[index];

                // TODO: Перевірте чи продукт вже в кошику
                final isInCart = ref.watch(
                  cartProvider.select((cart) =>
                      cart.any((item) => item.product.id == product.id)),
                );

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    // TODO: Додайте емодзі як leading
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        product.imageEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    // TODO: Додайте назву продукту
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // TODO: Додайте опис та ціну
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // TODO: Додайте кнопку "Add to Cart"
                    trailing: IconButton(
                      icon: Icon(
                        isInCart ? Icons.check_circle : Icons.add_shopping_cart,
                        color: isInCart ? Colors.green : Colors.blue,
                      ),
                      onPressed: () {
                        // TODO: Додайте продукт у кошик через cartProvider
                        // Використайте: ref.read(cartProvider.notifier).addProduct(product);

                        if (!isInCart) {
                          ref.read(cartProvider.notifier).addProduct(product);

                          // Показуємо SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ]));
  }
}
