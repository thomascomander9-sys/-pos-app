import 'package:flutter/material.dart';
import 'database_helper.dart';

/// ============================================================
/// شاشة المبيعات (نقطة البيع / الكاشير)
/// ============================================================
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // قائمة المنتجات المتاحة من قاعدة البيانات
  List<Map<String, dynamic>> _products = [];
  
  // سلة المشتريات الحالية
  final List<Map<String, dynamic>> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // تحميل المنتجات من قاعدة البيانات
  Future<void> _loadProducts() async {
    final data = await DatabaseHelper().getProducts();
    setState(() {
      _products = data;
    });
  }

  // إضافة منتج إلى سلة المشتريات
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      int index = _cart.indexWhere((item) => item['id'] == product['id']);
      if (index != -1) {
        _cart[index]['quantity'] += 1;
      } else {
        _cart.add({
          'id': product['id'],
          'name': product['name'],
          'price': product['price'],
          'quantity': 1,
        });
      }
    });
  }

  // حساب إجمالي المبلغ
  double get _totalAmount {
    return _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة المبيعات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: Row(
        children: [
          // قسم المنتجات
          Expanded(
            flex: 2,
            child: _products.isEmpty
                ? const Center(child: Text('لا توجد منتجات متاحة'))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final prod = _products[index];
                      return Card(
                        child: InkWell(
                          onTap: () => _addToCart(prod),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  prod['name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('${prod['price']} ر.س'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const VerticalDivider(width: 1),

          // قسم سلة المشتريات والحساب
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'سلة المشتريات',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final item = _cart[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text('${item['price']} × ${item['quantity']}'),
                        trailing: Text('${item['price'] * item['quantity']} ر.س'),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.teal.shade50,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_totalAmount.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _cart.isEmpty ? null : () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('إتمام البيع'),
                      ),
                    ],
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
