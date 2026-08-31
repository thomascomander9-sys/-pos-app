import 'package:flutter/material.dart';
import 'database_helper.dart';

/// ============================================================
/// شاشة إدارة المنتجات
/// ============================================================
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    final data = await DatabaseHelper().getProducts();
    setState(() {
      _products = data;
    });
  }

  void _showAddProductDialog() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة منتج جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'السعر'),
            ),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الكمية'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                await DatabaseHelper().insertProduct({
                  'name': _nameController.text,
                  'price': double.tryParse(_priceController.text) ?? 0.0,
                  'stock': int.tryParse(_stockController.text) ?? 0,
                });
                _nameController.clear();
                _priceController.clear();
                _stockController.clear();
                if (mounted) Navigator.pop(context);
                _refreshProducts();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
      ),
      body: _products.isEmpty
          ? const Center(child: Text('لا توجد منتجات مضافة بعد'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final item = _products[index];
                return ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text('السعر: ${item['price']} - الكمية: ${item['stock']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await DatabaseHelper().deleteProduct(item['id']);
                      _refreshProducts();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

