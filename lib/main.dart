import 'package:flutter/material.dart';

void main() {
  runApp(const RKPosApp());
}

class RKPosApp extends StatelessWidget {
  const RKPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RK Juice & Coffee Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF168447),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
      ),
      home: const PosHome(),
    );
  }
}

class Product {
  final String name;
  final double price;

  const Product(this.name, this.price);
}

class PosHome extends StatefulWidget {
  const PosHome({super.key});

  @override
  State<PosHome> createState() => _PosHomeState();
}

class _PosHomeState extends State<PosHome> {
  String selectedCategory = 'জুস';

  final Map<String, List<Product>> products = {
    'জুস': [
      Product('কমলার জুস', 100),
      Product('আপেলের জুস', 120),
      Product('লেবুর জুস', 40),
      Product('আনারসের জুস', 80),
    ],
    'কফি ও চা': [
      Product('লাল চা', 15),
      Product('রং চা', 20),
      Product('দুধ চা', 30),
      Product('মালাই চা', 50),
      Product('হট কফি', 80),
      Product('কোল্ড কফি', 120),
    ],
    'ফাস্টফুড': [
      Product('বার্গার', 120),
      Product('স্যান্ডউইচ', 80),
      Product('ফ্রেঞ্চ ফ্রাই', 70),
    ],
    'মিল্কশেক': [
      Product('চকলেট শেক', 120),
      Product('ভ্যানিলা শেক', 100),
      Product('স্ট্রবেরি শেক', 130),
    ],
  };

  final Map<String, int> cart = {};

  double get total {
    double sum = 0;
    cart.forEach((name, quantity) {
      for (final list in products.values) {
        for (final product in list) {
          if (product.name == name) {
            sum += product.price * quantity;
          }
        }
      }
    });
    return sum;
  }

  int get itemCount =>
      cart.values.fold(0, (sum, quantity) => sum + quantity);

  void addProduct(Product product) {
    setState(() {
      cart[product.name] = (cart[product.name] ?? 0) + 1;
    });
  }

  void changeQuantity(String name, int change) {
    setState(() {
      final next = (cart[name] ?? 0) + change;
      if (next <= 0) {
        cart.remove(name);
      } else {
        cart[name] = next;
      }
    });
  }

  void checkout() {
    if (cart.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('অর্ডার নিশ্চিত করুন'),
        content: Text(
          'মোট বিল: ৳${total.toStringAsFixed(0)}\n'
          'পণ্যের পরিমাণ: $itemCount টি',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ফিরে যান'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => cart.clear());
              Navigator.pop(context);
              ScaffoldMessenger.of(this.context).showSnackBar(
                const SnackBar(
                  content: Text('অর্ডার সম্পন্ন হয়েছে!'),
                ),
              );
            },
            child: const Text('নিশ্চিত করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProducts = products[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF168447),
        foregroundColor: Colors.white,
        title: const Text(
          'RK Juice & Coffee Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'পণ্যের ক্যাটাগরি',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 105,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                categoryButton('জুস', Icons.local_drink),
                categoryButton('কফি ও চা', Icons.coffee),
                categoryButton('ফাস্টফুড', Icons.fastfood),
                categoryButton('মিল্কশেক', Icons.icecream),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              selectedCategory,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: currentProducts.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.35,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = currentProducts[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => addProduct(product),
                  child: Card(
                    elevation: 1,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF168447),
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '৳${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Color(0xFF168447),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'যোগ করতে চাপ দিন',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'অর্ডারের মোট',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '৳${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF168447),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: cart.isEmpty ? null : showCart,
                    icon: const Icon(Icons.shopping_cart),
                    label: Text('কার্ট দেখুন ($itemCount টি)'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String name, IconData icon) {
    final selected = selectedCategory == name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () => setState(() => selectedCategory = name),
        child: Container(
          width: 90,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF168447) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF168447)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFF168447),
                size: 29,
              ),
              const SizedBox(height: 7),
              Text(
                name,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, refreshSheet) => Padding(
          padding: const EdgeInsets.all(18),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'অর্ডারের তালিকা',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...cart.entries.map((entry) {
                  Product? found;
                  for (final list in products.values) {
                    for (final p in list) {
                      if (p.name == entry.key) found = p;
                    }
                  }

                  if (found == null) return const SizedBox();

                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(
                      '৳${(found.price * entry.value).toStringAsFixed(0)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            changeQuantity(entry.key, -1);
                            refreshSheet(() {});
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text('${entry.value}'),
                        IconButton(
                          onPressed: () {
                            changeQuantity(entry.key, 1);
                            refreshSheet(() {});
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                Text(
                  'সর্বমোট: ৳${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: cart.isEmpty
                        ? null
                        : () {
                            Navigator.pop(sheetContext);
                            checkout();
                          },
                    child: const Text('অর্ডার নিশ্চিত করুন'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
