class TransactionOverview {
  final int id;
  final int bookingId;
  final String paymentMethod;
  final String description;
  final double amount;
  final DateTime? createTime;
  final DateTime? updateTime;
  final int status;
  final String statusName;

  const TransactionOverview({
    required this.id,
    required this.bookingId,
    required this.paymentMethod,
    required this.description,
    required this.amount,
    this.createTime,
    this.updateTime,
    required this.status,
    required this.statusName,
  });

  factory TransactionOverview.fromJson(Map<String, dynamic> jsonData) =>
      TransactionOverview(
        id: jsonData['id'],
        bookingId: jsonData['bookingId'],
        paymentMethod: jsonData['paymentMethod'],
        description: jsonData['description'],
        amount: jsonData['amount'],
        status: jsonData['status'],
        statusName: jsonData['statusName'],
        createTime: jsonData['createTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
        updateTime: jsonData['updateTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
      );
}
