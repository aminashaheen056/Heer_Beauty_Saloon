import 'package:flutter/material.dart';

import '../customer/data/app_store.dart';

// ---------------------------------------------------------------------------
// MODELS
// ---------------------------------------------------------------------------

class ServiceCategory {
  final String id;
  String name;
  String description;
  bool active;

  ServiceCategory({
    required this.id,
    required this.name,
    this.description = '',
    this.active = true,
  });
}

class ServiceItem {
  final String id;
  String name;
  String category; // category name
  String description;
  int price;
  int durationMinutes;
  String image;
  bool active;

  ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.image,
    this.active = true,
  });
}

class PackageItem {
  final String id;
  String name;
  String description;
  int price;
  int validityDays;
  String image;
  List<String> services;
  bool active;

  PackageItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.validityDays,
    required this.image,
    required this.services,
    this.active = true,
  });
}

class StaffMember {
  final String id;
  String name;
  String specialization;
  String experience;
  double rating;
  String phone;
  String email;
  String image;
  String description;
  bool active; // employed / visible
  bool onDuty; // currently available for bookings
  Set<String> workingDays;
  String startTime;
  String endTime;

  StaffMember({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.phone,
    required this.email,
    required this.image,
    required this.description,
    this.active = true,
    this.onDuty = true,
    Set<String>? workingDays,
    this.startTime = '10:00 AM',
    this.endTime = '08:00 PM',
  }) : workingDays = workingDays ??
      {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};
}

class AdminCustomer {
  final String id;
  String name;
  String email;
  String phone;
  String address;
  DateTime joined;
  bool blocked;

  AdminCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address = '',
    required this.joined,
    this.blocked = false,
  });
}

class AdminAppointment {
  final String id;
  String customerId;
  String customerName;
  String service;
  DateTime date;
  String time;
  int price;
  String status; // Pending, Upcoming, Completed, Cancelled
  String staffId;
  String staffName;
  String image;
  String notes;

  AdminAppointment({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.service,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    this.staffId = '',
    this.staffName = '',
    required this.image,
    this.notes = '',
  });
}

class AdminTransaction {
  final String id;
  String customerId;
  String customerName;
  String service;
  DateTime date;
  String method;
  int amount;
  String status; // Paid, Pending, Refunded, Failed

  AdminTransaction({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.service,
    required this.date,
    required this.method,
    required this.amount,
    required this.status,
  });
}

class RefundRequest {
  final String id;
  final AdminTransaction transaction;
  int amount;
  String reason;
  String status; // Pending, Approved, Rejected
  DateTime date;

  RefundRequest({
    required this.id,
    required this.transaction,
    required this.amount,
    required this.reason,
    required this.status,
    required this.date,
  });
}

class PackageUsage {
  final String service;
  final DateTime date;
  final String staffName;

  PackageUsage({
    required this.service,
    required this.date,
    required this.staffName,
  });
}

class PurchasedPackageItem {
  final String id;
  String customerId;
  String customerName;
  String packageName;
  int price;
  DateTime purchaseDate;
  DateTime expiryDate;
  int total;
  int remaining;
  String status; // Active, Completed, Cancelled
  String image;
  List<PackageUsage> usage;

  PurchasedPackageItem({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.packageName,
    required this.price,
    required this.purchaseDate,
    required this.expiryDate,
    required this.total,
    required this.remaining,
    this.status = 'Active',
    required this.image,
    List<PackageUsage>? usage,
  }) : usage = usage ?? [];

  /// Status shown to the admin (an active package past its expiry is Expired).
  String get currentStatus {
    if (status != 'Active') return status;
    final today = DateTime.now();
    final end = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    final now = DateTime(today.year, today.month, today.day);
    return end.isBefore(now) ? 'Expired' : 'Active';
  }
}

class OfferItem {
  final String id;
  String title;
  int discountPercent;
  String description;
  DateTime validUntil;
  String image;
  bool active;

  OfferItem({
    required this.id,
    required this.title,
    required this.discountPercent,
    required this.description,
    required this.validUntil,
    required this.image,
    this.active = true,
  });

  bool get expired {
    final t = DateTime.now();
    return DateTime(validUntil.year, validUntil.month, validUntil.day)
        .isBefore(DateTime(t.year, t.month, t.day));
  }
}

class GalleryItem {
  final String id;
  String title;
  String category;
  String image;

  GalleryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
  });
}

class AdminNotification {
  final String id;
  String title;
  String message;
  String audience;
  DateTime date;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.date,
  });
}

// ---------------------------------------------------------------------------
// STORE
// ---------------------------------------------------------------------------

/// In-memory store for the admin module (same approach as the customer
/// [AppStore]). Customer bookings, payments and packages created in the
/// customer app are pulled in automatically through [syncFromCustomerApp].
class AdminStore {
  AdminStore._();

  // ---------------- Admin account / settings ----------------
  static const List<String> weekDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];
  static const List<String> galleryCategories = [
    'Hair', 'Makeup', 'Nails', 'Skin',
  ];
  static const List<String> paymentMethods = [
    'Cash at Salon', 'JazzCash', 'Easypaisa', 'Debit/Credit Card',
  ];

  static bool loggedIn = false;
  static String adminName = 'Salon Admin';
  static String adminEmail = 'admin@heer.com';
  static String adminPhone = '0300-1234567';
  static String adminPassword = 'admin123';

  static String salonName = 'HEER Beauty Salon';
  static String salonPhone = '0300-1234567';
  static String salonAddress = 'Lahore, Pakistan';
  static String openingTime = '10:00 AM';
  static String closingTime = '08:00 PM';

  static bool onlineBooking = true;
  static bool autoConfirm = false;
  static bool acceptCash = true;
  static bool pushNotifications = true;

  // ---------------- Helpers ----------------
  static int _seq = 1000;
  static String nextId(String prefix) => '$prefix${_seq++}';

  static String money(int amount) => AppStore.formatPrice(amount);
  static String date(DateTime d) => AppStore.longDate(d);
  static String shortDate(DateTime d) => AppStore.shortDate(d);

  static const List<String> _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String dayMonth(DateTime d) => '${d.day} ${_shortMonths[d.month - 1]}';

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  static DateTime _daysFromNow(int n) =>
      today().add(Duration(days: n));

  static String formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  static TimeOfDay parseTime(String s) {
    try {
      final parts = s.trim().split(' ');
      final hm = parts[0].split(':');
      var h = int.parse(hm[0]);
      final m = int.parse(hm[1]);
      final pm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      if (pm && h < 12) h += 12;
      if (!pm && h == 12) h = 0;
      return TimeOfDay(hour: h, minute: m);
    } catch (_) {
      return const TimeOfDay(hour: 10, minute: 0);
    }
  }

  static String durationText(int minutes) {
    if (minutes % 60 == 0) {
      final h = minutes ~/ 60;
      return h == 1 ? '1 hour' : '$h hours';
    }
    return '$minutes min';
  }

  // ---------------- Data ----------------
  static final List<ServiceCategory> categories = [
    ServiceCategory(
        id: 'cat1', name: 'Hair', description: 'Cutting, styling, colour and treatments'),
    ServiceCategory(
        id: 'cat2', name: 'Makeup', description: 'Party, bridal and everyday makeup'),
    ServiceCategory(
        id: 'cat3', name: 'Nails', description: 'Manicure, pedicure and nail art'),
    ServiceCategory(
        id: 'cat4', name: 'Skin Care', description: 'Facials and skin treatments'),
  ];

  static final List<ServiceItem> services = [
    // Hair
    _svc('s1', 'Hair Cutting', 'Hair', 'Professional haircut and styling for a fresh and beautiful look.', 1500, 45, 'assets/images/hair.jpg'),
    _svc('s2', 'Hair Styling', 'Hair', 'Beautiful hairstyles for parties, events and special occasions.', 2000, 60, 'assets/images/hair_styling.jpg'),
    _svc('s3', 'Hair Coloring', 'Hair', 'Professional hair coloring and highlights for a stylish look.', 5000, 120, 'assets/images/hair2.jpg'),
    _svc('s4', 'Hair Treatment', 'Hair', 'Nourishing hair treatment to improve hair health and shine.', 3000, 60, 'assets/images/hair.jpg'),
    _svc('s5', 'Hair Straightening', 'Hair', 'Get smooth, sleek and straight hair with professional care.', 4000, 120, 'assets/images/hair2.jpg'),
    _svc('s6', 'Hair Spa', 'Hair', 'Relaxing hair spa with deep conditioning and nourishment.', 2500, 60, 'assets/images/hair.jpg'),
    // Makeup
    _svc('s7', 'Party Makeup', 'Makeup', 'Elegant makeup for parties and events.', 3500, 60, 'assets/images/party_makup.jpg'),
    _svc('s8', 'Bridal Makeup', 'Makeup', 'Complete bridal makeup for your special day.', 15000, 180, 'assets/images/bride.jpg'),
    _svc('s9', 'Engagement Makeup', 'Makeup', 'Beautiful makeup for engagement events.', 8000, 120, 'assets/images/bridal1.jpg'),
    _svc('s10', 'Natural Makeup', 'Makeup', 'Soft and natural everyday makeup look.', 2500, 45, 'assets/images/makeup.jpg'),
    _svc('s11', 'Eye Makeup', 'Makeup', 'Professional eye makeup and styling.', 1500, 30, 'assets/images/party1.jpg'),
    _svc('s12', 'Reception Makeup', 'Makeup', 'Glamorous makeup for reception events.', 10000, 120, 'assets/images/bridal3.jpg'),
    // Nails
    _svc('s13', 'Basic Manicure', 'Nails', 'Classic manicure with shaping and polish.', 1200, 30, 'assets/images/nail_art.jpg'),
    _svc('s14', 'Basic Pedicure', 'Nails', 'Relaxing pedicure with scrub and polish.', 1500, 45, 'assets/images/nail1.jpg'),
    _svc('s15', 'Nail Art', 'Nails', 'Creative nail art designs.', 2000, 60, 'assets/images/nail2.jpg'),
    _svc('s16', 'Gel Nails', 'Nails', 'Long lasting gel nail colour.', 2500, 60, 'assets/images/nail3.jpg'),
    _svc('s17', 'Acrylic Nails', 'Nails', 'Acrylic nail application.', 3500, 90, 'assets/images/nail4.jpg'),
    _svc('s18', 'Nail Extensions', 'Nails', 'Nail extensions for a longer look.', 3000, 75, 'assets/images/nail5.jpg'),
    // Skin
    _svc('s19', 'Basic Facial', 'Skin Care', 'Refreshing facial for healthy skin.', 2000, 45, 'assets/images/facial.jpg'),
    _svc('s20', 'Deep Cleansing Facial', 'Skin Care', 'Deep cleansing for clear, fresh skin.', 2500, 60, 'assets/images/facial1.jpg'),
    _svc('s21', 'Hydrating Facial', 'Skin Care', 'Intense hydration for dry skin.', 3000, 60, 'assets/images/facial.jpg'),
    _svc('s22', 'Brightening Facial', 'Skin Care', 'Brightening treatment for glowing skin.', 3500, 60, 'assets/images/facial1.jpg'),
    _svc('s23', 'Face Cleanup', 'Skin Care', 'Quick cleanup for a fresh face.', 1500, 30, 'assets/images/facial.jpg'),
    _svc('s24', 'Face Mask Treatment', 'Skin Care', 'Nourishing face mask treatment.', 1800, 40, 'assets/images/facial1.jpg'),
  ];

  static ServiceItem _svc(String id, String name, String category,
      String description, int price, int minutes, String image) {
    return ServiceItem(
      id: id,
      name: name,
      category: category,
      description: description,
      price: price,
      durationMinutes: minutes,
      image: image,
    );
  }

  static final List<PackageItem> packages = [
    PackageItem(
      id: 'p1',
      name: 'Bridal Glow Package',
      description:
      'A complete beauty package designed to make your special day memorable.',
      price: 25000,
      validityDays: 30,
      image: 'assets/images/bridal1.jpg',
      services: ['Bridal Makeup', 'Hair Styling', 'Facial', 'Manicure', 'Pedicure'],
    ),
    PackageItem(
      id: 'p2',
      name: 'Hair Care Package',
      description:
      'Give your hair the care and attention it deserves with our hair care package.',
      price: 8000,
      validityDays: 15,
      image: 'assets/images/hair2.jpg',
      services: ['Hair Spa', 'Hair Cutting', 'Hair Styling', 'Hair Treatment'],
    ),
    PackageItem(
      id: 'p3',
      name: 'Nail Care Package',
      description:
      'Enjoy beautiful and well-maintained nails with our nail care services.',
      price: 5000,
      validityDays: 15,
      image: 'assets/images/nail3.jpg',
      services: ['Manicure', 'Pedicure', 'Nail Art', 'Nail Polish'],
    ),
    PackageItem(
      id: 'p4',
      name: 'Complete Beauty Package',
      description:
      'A complete beauty experience covering hair, skin, makeup and nail care.',
      price: 15000,
      validityDays: 30,
      image: 'assets/images/salon.jpg',
      services: ['Facial', 'Hair Styling', 'Manicure', 'Pedicure', 'Party Makeup'],
    ),
  ];

  static final List<StaffMember> staff = [
    StaffMember(
      id: 'st1',
      name: 'Sana Malik',
      specialization: 'Hair Styling & Hair Colour',
      experience: '8 years',
      rating: 4.9,
      phone: '0301-1112233',
      email: 'sana@heer.com',
      image: 'assets/images/hair2.jpg',
      description:
      'Sana creates modern cuts, layers and colour looks that suit your face and lifestyle.',
    ),
    StaffMember(
      id: 'st2',
      name: 'Ayesha Khan',
      specialization: 'Bridal & Party Makeup',
      experience: '10 years',
      rating: 4.9,
      phone: '0302-2223344',
      email: 'ayesha@heer.com',
      image: 'assets/images/bride.jpg',
      description:
      'Ayesha is our lead makeup artist and has styled hundreds of brides for their big day.',
    ),
    StaffMember(
      id: 'st3',
      name: 'Hira Noor',
      specialization: 'Nail Art & Manicure',
      experience: '5 years',
      rating: 4.8,
      phone: '0303-3334455',
      email: 'hira@heer.com',
      image: 'assets/images/nail4.jpg',
      description:
      'Hira loves detailed nail art, gel colours and relaxing manicure and pedicure sessions.',
    ),
    StaffMember(
      id: 'st4',
      name: 'Mehwish Ali',
      specialization: 'Facials & Skin Care',
      experience: '7 years',
      rating: 4.8,
      phone: '0304-4445566',
      email: 'mehwish@heer.com',
      image: 'assets/images/facial.jpg',
      description:
      'Mehwish specialises in deep cleansing, hydrating and brightening facials for glowing skin.',
      workingDays: {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'},
    ),
  ];

  static final List<AdminCustomer> customers = [
    AdminCustomer(
        id: 'c1',
        name: 'Amina',
        email: 'amina@gmail.com',
        phone: '03001234567',
        address: 'Lahore, Pakistan',
        joined: _daysFromNow(-60)),
    AdminCustomer(
        id: 'c2',
        name: 'Sara Ahmed',
        email: 'sara.ahmed@gmail.com',
        phone: '03012345678',
        address: 'Gulberg, Lahore',
        joined: _daysFromNow(-45)),
    AdminCustomer(
        id: 'c3',
        name: 'Fatima Zahra',
        email: 'fatima.z@gmail.com',
        phone: '03023456789',
        address: 'DHA Phase 5, Lahore',
        joined: _daysFromNow(-30)),
    AdminCustomer(
        id: 'c4',
        name: 'Zainab Iqbal',
        email: 'zainab.iqbal@gmail.com',
        phone: '03034567890',
        address: 'Model Town, Lahore',
        joined: _daysFromNow(-22)),
    AdminCustomer(
        id: 'c5',
        name: 'Maryam Siddiqui',
        email: 'maryam.s@gmail.com',
        phone: '03045678901',
        address: 'Johar Town, Lahore',
        joined: _daysFromNow(-14)),
    AdminCustomer(
        id: 'c6',
        name: 'Hina Raza',
        email: 'hina.raza@gmail.com',
        phone: '03056789012',
        address: 'Bahria Town, Lahore',
        joined: _daysFromNow(-7)),
  ];

  static final List<AdminAppointment> _appointments = _seedAppointments();
  static final List<AdminTransaction> _transactions = _seedTransactions();
  static final List<PurchasedPackageItem> _purchased = _seedPurchased();

  static final List<RefundRequest> refunds = _seedRefunds();

  static final List<OfferItem> offers = [
    OfferItem(
        id: 'o1',
        title: 'Bridal Makeup',
        discountPercent: 20,
        description: 'Get a beautiful bridal makeover at a special discounted price.',
        validUntil: DateTime(2026, 11, 30),
        image: 'assets/images/bridal2.jpg'),
    OfferItem(
        id: 'o2',
        title: 'Hair Styling',
        discountPercent: 15,
        description: 'Enjoy professional hair styling with our expert stylists.',
        validUntil: DateTime(2026, 11, 30),
        image: 'assets/images/hair.jpg'),
    OfferItem(
        id: 'o3',
        title: 'Nail Art',
        discountPercent: 10,
        description: 'Give your nails a stylish look with our special nail art offer.',
        validUntil: DateTime(2026, 11, 25),
        image: 'assets/images/nail2.jpg'),
    OfferItem(
        id: 'o4',
        title: 'Facial Treatment',
        discountPercent: 25,
        description: 'Refresh your skin with our relaxing facial treatment.',
        validUntil: DateTime(2026, 11, 25),
        image: 'assets/images/facial.jpg'),
  ];

  static final List<GalleryItem> gallery = [
    GalleryItem(id: 'g1', title: 'Elegant Hair Styling', category: 'Hair', image: 'assets/images/hair.jpg'),
    GalleryItem(id: 'g2', title: 'Bridal Hairstyle', category: 'Hair', image: 'assets/images/hair2.jpg'),
    GalleryItem(id: 'g3', title: 'Party Makeup', category: 'Makeup', image: 'assets/images/makeup.jpg'),
    GalleryItem(id: 'g4', title: 'Bridal Makeup', category: 'Makeup', image: 'assets/images/party_makup.jpg'),
    GalleryItem(id: 'g5', title: 'Nail Art Design', category: 'Nails', image: 'assets/images/nail1.jpg'),
    GalleryItem(id: 'g6', title: 'Elegant Nail Art', category: 'Nails', image: 'assets/images/nail4.jpg'),
    GalleryItem(id: 'g7', title: 'Facial Treatment', category: 'Skin', image: 'assets/images/facial.jpg'),
    GalleryItem(id: 'g8', title: 'Skin Care', category: 'Skin', image: 'assets/images/facial1.jpg'),
  ];

  static final List<AdminNotification> notifications = [
    AdminNotification(
        id: 'n1',
        title: 'Bridal Season Offer',
        message: 'Get 20% OFF on Bridal Makeup until 30 November. Book now!',
        audience: 'All Customers',
        date: _daysFromNow(-3)),
    AdminNotification(
        id: 'n2',
        title: 'New Facial Treatments',
        message: 'We have added brightening and hydrating facials to our menu.',
        audience: 'All Customers',
        date: _daysFromNow(-6)),
    AdminNotification(
        id: 'n3',
        title: 'Package Expiry Reminder',
        message: 'Your Hair Care Package expires in 3 days. Visit us to use your remaining services.',
        audience: 'Package Holders',
        date: _daysFromNow(-1)),
    AdminNotification(
        id: 'n4',
        title: 'Staff Meeting',
        message: 'Monthly staff meeting on Saturday at 9:30 AM before opening.',
        audience: 'Staff',
        date: _daysFromNow(-8)),
  ];

  // ---------------- Seeds ----------------
  static List<AdminAppointment> _seedAppointments() {
    AdminAppointment a(String id, String cid, String service, int offset,
        String time, int price, String status, String staffId) {
      final c = customers.firstWhere((e) => e.id == cid);
      final s = staffId.isEmpty
          ? null
          : staff.firstWhere((e) => e.id == staffId);
      return AdminAppointment(
        id: id,
        customerId: cid,
        customerName: c.name,
        service: service,
        date: _daysFromNow(offset),
        time: time,
        price: price,
        status: status,
        staffId: staffId,
        staffName: s?.name ?? '',
        image: serviceImage(service),
      );
    }

    return [
      a('a1', 'c2', 'Hair Styling', 0, '11:00 AM', 2000, 'Upcoming', 'st1'),
      a('a2', 'c3', 'Bridal Makeup', 0, '02:00 PM', 15000, 'Upcoming', 'st2'),
      a('a3', 'c4', 'Gel Nails', 0, '04:30 PM', 2500, 'Pending', ''),
      a('a4', 'c1', 'Hydrating Facial', 1, '12:00 PM', 3000, 'Upcoming', 'st4'),
      a('a5', 'c5', 'Hair Coloring', 2, '03:00 PM', 5000, 'Pending', ''),
      a('a6', 'c6', 'Party Makeup', 3, '06:00 PM', 3500, 'Upcoming', 'st2'),
      a('a7', 'c2', 'Basic Manicure', -1, '01:00 PM', 1200, 'Completed', 'st3'),
      a('a8', 'c3', 'Hair Cutting', -2, '10:30 AM', 1500, 'Completed', 'st1'),
      a('a9', 'c4', 'Deep Cleansing Facial', -3, '05:00 PM', 2500, 'Completed', 'st4'),
      a('a10', 'c5', 'Eye Makeup', -4, '07:00 PM', 1500, 'Cancelled', 'st2'),
      a('a11', 'c1', 'Nail Art', -5, '03:30 PM', 2000, 'Completed', 'st3'),
      a('a12', 'c6', 'Hair Spa', -7, '11:30 AM', 2500, 'Completed', 'st1'),
    ];
  }

  static List<AdminTransaction> _seedTransactions() {
    AdminTransaction t(String id, String cid, String service, int amount,
        String method, String status, int offset) {
      final c = customers.firstWhere((e) => e.id == cid);
      return AdminTransaction(
        id: id,
        customerId: cid,
        customerName: c.name,
        service: service,
        date: _daysFromNow(offset),
        method: method,
        amount: amount,
        status: status,
      );
    }

    return [
      t('HEER-1001', 'c3', 'Hair Cutting', 1500, 'Cash at Salon', 'Paid', -2),
      t('HEER-1002', 'c2', 'Basic Manicure', 1200, 'JazzCash', 'Paid', -1),
      t('HEER-1003', 'c4', 'Deep Cleansing Facial', 2500, 'Debit/Credit Card', 'Paid', -3),
      t('HEER-1004', 'c1', 'Nail Art', 2000, 'Cash at Salon', 'Paid', -5),
      t('HEER-1005', 'c6', 'Hair Spa', 2500, 'Easypaisa', 'Paid', -7),
      t('HEER-1006', 'c3', 'Bridal Glow Package', 25000, 'Debit/Credit Card', 'Paid', -10),
      t('HEER-1007', 'c2', 'Hair Care Package', 8000, 'JazzCash', 'Paid', -12),
      t('HEER-1008', 'c5', 'Eye Makeup', 1500, 'JazzCash', 'Refunded', -4),
      t('HEER-1009', 'c3', 'Bridal Makeup', 15000, 'Cash at Salon', 'Pending', 0),
      t('HEER-1010', 'c4', 'Gel Nails', 2500, 'Cash at Salon', 'Pending', 0),
      t('HEER-1011', 'c6', 'Nail Care Package', 5000, 'Easypaisa', 'Paid', -20),
      t('HEER-1012', 'c1', 'Complete Beauty Package', 15000, 'Debit/Credit Card', 'Paid', -20),
      t('HEER-1013', 'c5', 'Hair Coloring', 5000, 'Debit/Credit Card', 'Failed', -2),
      t('HEER-1014', 'c2', 'Hair Styling', 2000, 'Cash at Salon', 'Pending', 0),
      t('HEER-1015', 'c6', 'Party Makeup', 3500, 'JazzCash', 'Paid', -25),
      t('HEER-1016', 'c4', 'Hair Cutting', 1500, 'Cash at Salon', 'Paid', -40),
    ];
  }

  static List<PurchasedPackageItem> _seedPurchased() {
    AdminCustomer c(String id) => customers.firstWhere((e) => e.id == id);
    return [
      PurchasedPackageItem(
        id: 'pp1',
        customerId: 'c3',
        customerName: c('c3').name,
        packageName: 'Bridal Glow Package',
        price: 25000,
        purchaseDate: _daysFromNow(-10),
        expiryDate: _daysFromNow(20),
        total: 5,
        remaining: 3,
        image: 'assets/images/bridal1.jpg',
        usage: [
          PackageUsage(service: 'Facial', date: _daysFromNow(-8), staffName: 'Mehwish Ali'),
          PackageUsage(service: 'Hair Styling', date: _daysFromNow(-6), staffName: 'Sana Malik'),
        ],
      ),
      PurchasedPackageItem(
        id: 'pp2',
        customerId: 'c2',
        customerName: c('c2').name,
        packageName: 'Hair Care Package',
        price: 8000,
        purchaseDate: _daysFromNow(-12),
        expiryDate: _daysFromNow(3),
        total: 4,
        remaining: 2,
        image: 'assets/images/hair2.jpg',
        usage: [
          PackageUsage(service: 'Hair Spa', date: _daysFromNow(-9), staffName: 'Sana Malik'),
          PackageUsage(service: 'Hair Cutting', date: _daysFromNow(-4), staffName: 'Sana Malik'),
        ],
      ),
      PurchasedPackageItem(
        id: 'pp3',
        customerId: 'c6',
        customerName: c('c6').name,
        packageName: 'Nail Care Package',
        price: 5000,
        purchaseDate: _daysFromNow(-20),
        expiryDate: _daysFromNow(-5),
        total: 4,
        remaining: 4,
        image: 'assets/images/nail3.jpg',
      ),
      PurchasedPackageItem(
        id: 'pp4',
        customerId: 'c1',
        customerName: c('c1').name,
        packageName: 'Complete Beauty Package',
        price: 15000,
        purchaseDate: _daysFromNow(-20),
        expiryDate: _daysFromNow(10),
        total: 5,
        remaining: 5,
        image: 'assets/images/salon.jpg',
      ),
    ];
  }

  static List<RefundRequest> _seedRefunds() {
    AdminTransaction tx(String id) =>
        _transactions.firstWhere((e) => e.id == id);
    return [
      RefundRequest(
        id: 'r1',
        transaction: tx('HEER-1005'),
        amount: 2500,
        reason: 'Customer was not satisfied with the service quality.',
        status: 'Pending',
        date: _daysFromNow(-1),
      ),
      RefundRequest(
        id: 'r2',
        transaction: tx('HEER-1007'),
        amount: 4000,
        reason: 'Partial refund for unused package services (customer relocating).',
        status: 'Pending',
        date: _daysFromNow(0),
      ),
      RefundRequest(
        id: 'r3',
        transaction: tx('HEER-1008'),
        amount: 1500,
        reason: 'Appointment cancelled by customer in advance.',
        status: 'Approved',
        date: _daysFromNow(-4),
      ),
      RefundRequest(
        id: 'r4',
        transaction: tx('HEER-1001'),
        amount: 1500,
        reason: 'Changed mind after the service was completed.',
        status: 'Rejected',
        date: _daysFromNow(-2),
      ),
    ];
  }

  // ---------------- Sync with customer app ----------------
  static final Set<Object> _imported = {};
  static const List<String> _monthPrefix = [
    'jan', 'feb', 'mar', 'apr', 'may', 'jun',
    'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
  ];

  static DateTime _parseLongDate(String s) {
    try {
      final p = s.trim().split(' ');
      final m = _monthPrefix.indexOf(p[1].toLowerCase().substring(0, 3));
      if (m < 0) return DateTime.now();
      return DateTime(int.parse(p[2]), m + 1, int.parse(p[0]));
    } catch (_) {
      return DateTime.now();
    }
  }

  static DateTime _parseShortDate(String s) {
    try {
      final p = s.trim().split('/');
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Imports bookings, payments and packages that were created in the
  /// customer app so the admin sees them live.
  static void syncFromCustomerApp() {
    for (final m in AppStore.appointments.reversed) {
      if (_imported.contains(m)) continue;
      _imported.add(m);
      final name = m['name'] ?? 'Service';
      _appointments.insert(
        0,
        AdminAppointment(
          id: nextId('a'),
          customerId: 'c1',
          customerName: customers.first.name,
          service: name,
          date: _parseLongDate(m['date'] ?? ''),
          time: m['time'] ?? '',
          price: AppStore.parsePrice(m['price'] ?? ''),
          status: autoConfirm ? 'Upcoming' : (m['status'] == 'Upcoming' ? 'Pending' : (m['status'] ?? 'Pending')),
          image: m['image'] ?? serviceImage(name),
        ),
      );
    }

    for (final m in AppStore.transactions.reversed) {
      if (_imported.contains(m)) continue;
      _imported.add(m);
      _transactions.insert(
        0,
        AdminTransaction(
          id: '${m['id']}',
          customerId: 'c1',
          customerName: customers.first.name,
          service: '${m['service']}',
          date: _parseShortDate('${m['date']}'),
          method: '${m['method']}',
          amount: (m['amount'] as num?)?.toInt() ?? 0,
          status: '${m['status']}',
        ),
      );
    }

    for (final m in AppStore.purchasedPackages.reversed) {
      if (_imported.contains(m)) continue;
      _imported.add(m);
      _purchased.insert(
        0,
        PurchasedPackageItem(
          id: nextId('pp'),
          customerId: 'c1',
          customerName: customers.first.name,
          packageName: '${m['name']}',
          price: AppStore.parsePrice('${m['price']}'),
          purchaseDate: _parseLongDate('${m['purchaseDate']}'),
          expiryDate: _parseLongDate('${m['expiryDate']}'),
          total: (m['total'] as num?)?.toInt() ?? 0,
          remaining: (m['remaining'] as num?)?.toInt() ?? 0,
          image: '${m['image']}',
        ),
      );
    }
  }

  static List<AdminAppointment> get appointments {
    syncFromCustomerApp();
    return _appointments;
  }

  static List<AdminTransaction> get transactions {
    syncFromCustomerApp();
    return _transactions;
  }

  static List<PurchasedPackageItem> get purchasedPackages {
    syncFromCustomerApp();
    return _purchased;
  }

  // ---------------- Lookups ----------------
  static AdminCustomer? findCustomer(String id) {
    for (final c in customers) {
      if (c.id == id) return c;
    }
    return null;
  }

  static StaffMember? findStaff(String id) {
    for (final s in staff) {
      if (s.id == id) return s;
    }
    return null;
  }

  static List<StaffMember> get activeStaff =>
      staff.where((s) => s.active).toList();

  static String serviceImage(String name) {
    for (final s in services) {
      if (s.name == name) return s.image;
    }
    return 'assets/images/salon.jpg';
  }

  static String categoryOfService(String name) {
    for (final s in services) {
      if (s.name == name) return s.category;
    }
    for (final p in packages) {
      if (p.name == name) return 'Packages';
    }
    if (name.toLowerCase().contains('package')) return 'Packages';
    return 'Other';
  }

  static PackageItem? packageByName(String name) {
    for (final p in packages) {
      if (p.name == name) return p;
    }
    return null;
  }

  static List<AdminAppointment> appointmentsOfCustomer(String id) =>
      appointments.where((a) => a.customerId == id).toList();

  static List<AdminTransaction> transactionsOfCustomer(String id) =>
      transactions.where((t) => t.customerId == id).toList();

  static List<PurchasedPackageItem> packagesOfCustomer(String id) =>
      purchasedPackages.where((p) => p.customerId == id).toList();

  static List<AdminAppointment> appointmentsOfStaff(String id) =>
      appointments.where((a) => a.staffId == id).toList();

  // ---------------- Notifications ----------------
  static void addNotification(String title, String message, String audience) {
    notifications.insert(
      0,
      AdminNotification(
        id: nextId('n'),
        title: title,
        message: message,
        audience: audience,
        date: DateTime.now(),
      ),
    );
  }

  // ---------------- Appointments ----------------
  static void updateAppointmentStatus(AdminAppointment a, String status) {
    a.status = status;
    addNotification(
      'Appointment $status',
      'Your ${a.service} appointment on ${date(a.date)} at ${a.time} is now $status.',
      a.customerName,
    );
  }

  static void assignStaff(AdminAppointment a, StaffMember? s) {
    a.staffId = s?.id ?? '';
    a.staffName = s?.name ?? '';
  }

  static AdminAppointment addAppointment({
    required AdminCustomer customer,
    required ServiceItem service,
    required DateTime day,
    required String time,
    StaffMember? staffMember,
  }) {
    final a = AdminAppointment(
      id: nextId('a'),
      customerId: customer.id,
      customerName: customer.name,
      service: service.name,
      date: day,
      time: time,
      price: service.price,
      status: 'Upcoming',
      staffId: staffMember?.id ?? '',
      staffName: staffMember?.name ?? '',
      image: service.image,
    );
    _appointments.insert(0, a);
    return a;
  }

  // ---------------- Payments ----------------
  static void addTransaction({
    required AdminCustomer customer,
    required String service,
    required int amount,
    required String method,
    String status = 'Paid',
  }) {
    _transactions.insert(
      0,
      AdminTransaction(
        id: 'HEER-${DateTime.now().millisecondsSinceEpoch}',
        customerId: customer.id,
        customerName: customer.name,
        service: service,
        date: DateTime.now(),
        method: method,
        amount: amount,
        status: status,
      ),
    );
  }

  static void requestRefund(AdminTransaction t, int amount, String reason) {
    refunds.insert(
      0,
      RefundRequest(
        id: nextId('r'),
        transaction: t,
        amount: amount,
        reason: reason,
        status: 'Pending',
        date: DateTime.now(),
      ),
    );
  }

  static void approveRefund(RefundRequest r) {
    r.status = 'Approved';
    r.transaction.status = 'Refunded';
    addNotification(
      'Refund Approved',
      'Your refund of ${money(r.amount)} for ${r.transaction.service} has been approved.',
      r.transaction.customerName,
    );
  }

  static void rejectRefund(RefundRequest r) {
    r.status = 'Rejected';
    addNotification(
      'Refund Rejected',
      'Your refund request for ${r.transaction.service} could not be approved.',
      r.transaction.customerName,
    );
  }

  // ---------------- Packages ----------------
  static PurchasedPackageItem sellPackage({
    required AdminCustomer customer,
    required PackageItem package,
    required String method,
  }) {
    final now = DateTime.now();
    final p = PurchasedPackageItem(
      id: nextId('pp'),
      customerId: customer.id,
      customerName: customer.name,
      packageName: package.name,
      price: package.price,
      purchaseDate: now,
      expiryDate: now.add(Duration(days: package.validityDays)),
      total: package.services.length,
      remaining: package.services.length,
      image: package.image,
    );
    _purchased.insert(0, p);
    addTransaction(
      customer: customer,
      service: package.name,
      amount: package.price,
      method: method,
    );
    return p;
  }

  static void redeemPackageService(
      PurchasedPackageItem p, String service, String staffName) {
    if (p.remaining <= 0) return;
    p.remaining -= 1;
    p.usage.add(PackageUsage(
        service: service, date: DateTime.now(), staffName: staffName));
    if (p.remaining == 0) p.status = 'Completed';
  }

  // ---------------- Finance / reports ----------------
  static List<AdminTransaction> paidBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    return transactions
        .where((t) =>
    t.status == 'Paid' &&
        !t.date.isBefore(start) &&
        !t.date.isAfter(end))
        .toList();
  }

  static int sum(Iterable<AdminTransaction> list) =>
      list.fold<int>(0, (a, t) => a + t.amount);

  static int get totalRevenue =>
      sum(transactions.where((t) => t.status == 'Paid'));

  static int get pendingAmount =>
      sum(transactions.where((t) => t.status == 'Pending'));

  static int get refundedAmount =>
      sum(transactions.where((t) => t.status == 'Refunded'));

  static int revenueOn(DateTime day) => sum(transactions.where(
          (t) => t.status == 'Paid' && sameDay(t.date, day)));

  /// Revenue per day for the last [days] days (oldest first).
  static List<MapEntry<DateTime, int>> dailyRevenue(int days) {
    final out = <MapEntry<DateTime, int>>[];
    for (int i = days - 1; i >= 0; i--) {
      final d = _daysFromNow(-i);
      out.add(MapEntry(d, revenueOn(d)));
    }
    return out;
  }

  static Map<String, int> revenueByCategory(List<AdminTransaction> list) {
    final map = <String, int>{};
    for (final t in list) {
      final c = categoryOfService(t.service);
      map[c] = (map[c] ?? 0) + t.amount;
    }
    return map;
  }

  static Map<String, int> revenueByMethod(List<AdminTransaction> list) {
    final map = <String, int>{};
    for (final t in list) {
      map[t.method] = (map[t.method] ?? 0) + t.amount;
    }
    return map;
  }

  static int get pendingRefundCount =>
      refunds.where((r) => r.status == 'Pending').length;
}
