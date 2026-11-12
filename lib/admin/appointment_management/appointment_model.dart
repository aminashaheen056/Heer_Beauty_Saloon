
class Appointment {
  final String id;
  final String customerName;
  final String customerEmail;
  final String phone;
  final String service;
  String beautician;
  String date;
  String time;
  final double price;
  String status;
  String paymentStatus;
  String notes;

  Appointment({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.phone,
    required this.service,
    required this.beautician,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    required this.paymentStatus,
    this.notes = 'No additional notes',
  });
}
