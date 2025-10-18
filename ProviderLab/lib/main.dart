// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Cart — 4-Layer Provider',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

/* ---------------------- Shared State (Business Logic) ---------------------- */

class CartModel extends ChangeNotifier {
  final Map<String, double> _productPrices = {
    'Apples': 1.50,
    'Bananas': 0.99,
    'Cookies': 3.25,
    'Milk': 2.25,
    'Bread': 2.00,
  };

  final List<String> _items = [];
  List<String> get items => List.unmodifiable(_items);

  double get totalPrice => _items.fold(
    0.0,
        (sum, item) => sum + (_productPrices[item] ?? 0),
  );

  double? priceOf(String item) => _productPrices[item];

  int get count => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(String item) {
    _items.remove(item);
    notifyListeners();
  }
}

/* --------------------------------- UI ------------------------------------- */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = const ['Apples', 'Bananas', 'Cookies', 'Milk', 'Bread'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop — Provider (4 layers)'),
        actions: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 28),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        context.watch<CartModel>().count.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ProductList(products: products),
    );
  }
}

/* -------------------------- Layer 2: Product List -------------------------- */

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.products});
  final List<String> products;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: products.map((p) => ProductTile(name: p)).toList(),
    );
  }
}

/* --------------------------- Layer 3: Product Tile -------------------------- */

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final price = context.read<CartModel>().priceOf(name) ?? 0;

    return ListTile(
      title: Text('$name — \$${price.toStringAsFixed(2)}'),
      trailing: ElevatedButton(
        onPressed: () => context.read<CartModel>().add(name),
        child: const Text('Add'),
      ),
      // 👇 NEW: Navigate to 4th layer (Product Detail)
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(name: name),
        ),
      ),
    );
  }
}

/* --------------------- Layer 4: Product Detail Screen ---------------------- */

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final price = cart.priceOf(name) ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style:
                const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Price: \$${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
                onPressed: () {
                  context.read<CartModel>().add(name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added to cart!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------- Cart Screen -------------------------------- */

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                final price = cart.priceOf(item) ?? 0;
                return ListTile(
                  title: Text(item),
                  subtitle:
                  Text('\$${price.toStringAsFixed(2)} each'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => context.read<CartModel>().remove(item),
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
