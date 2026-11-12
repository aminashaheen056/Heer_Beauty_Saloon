
class PackageModel {
  final String id;
  String name;
  String description;
  double price;
  int discount;
  int validityDays;
  List<String> services;
  bool isActive;

  PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discount = 0,
    this.validityDays = 30,
    List<String>? services,
    this.isActive = true,
  }) : services = services ?? [];

  double get discountedPrice =>
      price - (price * discount / 100);

  int get totalServices => services.length;
}

class PurchasedPackage {
  final String id;
  final String customerName;
  final String customerPhone;
  final PackageModel package;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  int usedServices;
  String status;

  PurchasedPackage({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.package,
    required this.purchaseDate,
    required this.expiryDate,
    this.usedServices = 0,
    this.status = 'Active',
  });

  int get remainingServices =>
      (package.totalServices - usedServices)
          .clamp(0, package.totalServices);

  double get usagePercentage => package.totalServices == 0
      ? 0
      : usedServices / package.totalServices;
}
