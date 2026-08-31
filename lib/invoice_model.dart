class Invoice {
  final int? id;
  final String invoiceNumber;
  final String date;
  final double totalAmount;

  Invoice({
    this.id,
    required this.invoiceNumber,
    required this.date,
    required this.totalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'date': date,
      'totalAmount': totalAmount,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'],
      date: map['date'],
      totalAmount: map['totalAmount'],
    );
  }
}
