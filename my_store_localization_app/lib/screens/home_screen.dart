import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_store_localization_app/l10n/app_localizations.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _products = [];
  final Map<String, String> _newProductNames = {
    'uk': 'Новий товар',
    'en': 'New product',
    'pl': 'Nowy produkt',
    'fr': 'Nouveau produit',
    'ar': 'منتج جديد',
  };

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _products.addAll([
        {
          'icon': '👕',
          'name': {
            'uk': 'Футболка',
            'en': 'T-Shirt',
            'pl': 'Koszulka',
            'fr': 'T-shirt',
            'ar': 'قميص',
          },
          'price': 250.0,
          'date': DateTime(2026, 2, 13),
        },
        {
          'icon': '👟',
          'name': {
            'uk': 'Кросівки',
            'en': 'Sneakers',
            'pl': 'Sneakersy',
            'fr': 'Baskets',
            'ar': 'حذاء رياضي',
          },
          'price': 1500.0,
          'date': DateTime(2026, 2, 12),
        },
      ]);
      _isLoading = false;
    });
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.areYouSure),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _products.removeAt(index));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.productDeleted)));
      }
    }
  }

  void _addProduct(BuildContext context, AppLocalizations l10n) {
    setState(() {
      _products.add({
        'icon': '🛍️',
        'name': _newProductNames,
        'price': 100.0,
        'date': DateTime.now(),
      });
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.productAdded)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [_buildProductsScreen(l10n), const SettingsScreen()];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag),
            label: l10n.productsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsTab,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsScreen(AppLocalizations l10n) {
    final totalPrice = _products.fold<double>(
      0,
      (sum, p) => sum + (p['price'] as double),
    );

    final locale = Localizations.localeOf(context).toString();
    final lang = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.yMMMMd(locale);

    String currencySymbol;
    switch (Localizations.localeOf(context).languageCode) {
      case 'uk':
        currencySymbol = '₴';
        break;
      case 'pl':
        currencySymbol = 'zł';
        break;
      case 'fr':
        currencySymbol = '€';
        break;
      case 'ar':
        currencySymbol = 'د.إ';
        break;
      default:
        currencySymbol = '\$';
    }
    final currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.add,
            onPressed: () => _addProduct(context, l10n),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l10n.loading),
                ],
              ),
            )
          : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noProductsYet,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.add),
                    onPressed: () => _addProduct(context, l10n),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Text(
                            product['icon'],
                            style: const TextStyle(fontSize: 32),
                          ),
                          title: Text(
                            (product['name'] as Map<String, String>)[lang] ??
                                (product['name'] as Map<String, String>)['en']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.totalPrice(
                                  currencyFormat.format(
                                    product['price'] as double,
                                  ),
                                ),
                              ),
                              Text(
                                l10n.addedDate(
                                  dateFormat.format(
                                    product['date'] as DateTime,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            tooltip: l10n.delete,
                            onPressed: () =>
                                _confirmDelete(context, l10n, index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📊 ${l10n.itemsCount(_products.length)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '💰 ${l10n.totalPrice(currencyFormat.format(totalPrice))}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
