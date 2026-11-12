// Simple in-memory store so that new bookings, payments and packages
// show up in the "My Appointments", "Payment History" and
// "My Purchased Packages" screens during the app session.
class AppStore {
  static final List<Map<String, String>> appointments = [];
  static final List<Map<String, dynamic>> transactions = [];
  static final List<Map<String, dynamic>> purchasedPackages = [];

  // Converts text such as "Rs. 2,500" into the number 2500.
  static int parsePrice(String text) {
    return int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  static String formatPrice(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return 'Rs. $buffer';
  }

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  static String longDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  static String shortDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  // Newest entries first.
  static void addBooking({
    required String serviceName,
    required DateTime date,
    required String time,
    required int amount,
    required String paymentMethod,
    required String receiptNumber,
    required String image,
  }) {
    appointments.insert(0, {
      'name': serviceName,
      'date': longDate(date),
      'time': time,
      'price': formatPrice(amount),
      'status': 'Upcoming',
      'image': image,
    });
    transactions.insert(0, {
      'id': receiptNumber,
      'service': serviceName,
      'date': shortDate(DateTime.now()),
      'method': paymentMethod,
      'amount': amount,
      'status': paymentMethod == 'Cash at Salon' ? 'Pending' : 'Paid',
    });
  }

  static void addPackage({
    required String name,
    required String price,
    required String validity,
    required String image,
    required int totalServices,
  }) {
    final now = DateTime.now();
    final days = int.tryParse(validity.replaceAll(RegExp(r'[^0-9]'), '')) ?? 30;
    final shortMonths = _months.map((m) => m.substring(0, 3)).toList();
    String f(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')} ${shortMonths[d.month - 1]} ${d.year}';
    purchasedPackages.insert(0, {
      'name': name,
      'price': price,
      'purchaseDate': f(now),
      'expiryDate': f(now.add(Duration(days: days))),
      'status': 'Active',
      'remaining': totalServices,
      'total': totalServices,
      'image': image,
    });
    transactions.insert(0, {
      'id': 'HEER-${now.millisecondsSinceEpoch}',
      'service': name,
      'date': shortDate(now),
      'method': 'Cash at Salon',
      'amount': parsePrice(price),
      'status': 'Pending',
    });
  }
}
