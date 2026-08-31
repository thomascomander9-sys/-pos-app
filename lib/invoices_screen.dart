import 'package:flutter/material.dart';
import 'database_helper.dart';

/// ============================================================
/// شاشة سجل الفواتير
/// ============================================================
class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final data = await DatabaseHelper().getInvoices();
    setState(() {
      _invoices = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الفواتير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInvoices,
          ),
        ],
      ),
      body: _invoices.isEmpty
          ? const Center(child: Text('لا توجد فواتير مسجلة بعد'))
          : ListView.builder(
              itemCount: _invoices.length,
              itemBuilder: (context, index) {
                final inv = _invoices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.receipt, color: Colors.teal),
                    title: Text('فاتورة رقم: ${inv['invoiceNumber'] ?? inv['id']}'),
                    subtitle: Text('التاريخ: ${inv['date'] ?? ''} - طريقة الدفع: ${inv['paymentMethod'] ?? 'نقداً'}'),
                    trailing: Text(
                      '${inv['totalAmount']} ر.س',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

