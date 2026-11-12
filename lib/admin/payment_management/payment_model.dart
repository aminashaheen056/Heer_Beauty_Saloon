
class PaymentModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String serviceName;
  final DateTime date;
  final double amount;
  final String method;

  String status;
  String refundStatus;
  double refundAmount;

  PaymentModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceName,
    required this.date,
    required this.amount,
    required this.method,
    this.status = 'Paid',
    this.refundStatus = 'None',
    this.refundAmount = 0,
  });
}
