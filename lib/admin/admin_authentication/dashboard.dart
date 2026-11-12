import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import '../appointment_management/all_appointment.dart';
import '../appointment_management/appointments_detail.dart';
import '../appointment_management/manage_appointments.dart';
import '../customer_management/all_customers.dart';
import '../gallery_management/manage_gallery.dart';
import '../gallery_management/manage_offers.dart';
import '../notification/notification_history.dart';
import '../notification/revenue_report_screen.dart';
import '../package_management/manage_packages.dart';
import '../package_management/package_usage_management.dart';
import '../package_management/purchased_packages.dart';
import '../payment_management/all_transactions.dart';
import '../payment_management/finance_dashboard.dart';
import '../payment_management/manage_payments.dart';
import '../payment_management/refund_payement_management.dart';
import '../services_management/manage_Services_catogories.dart';
import '../services_management/manage_services.dart';
import '../staff_management/all_staff.dart';
import '../staff_management/manage_staff_availability.dart';
import 'profile.dart';
import 'setting.dart';
import 'staff_login.dart';

class _MenuItem {
  final String title;
  final IconData icon;
  final Widget Function() page;
  const _MenuItem(this.title, this.icon, this.page);
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  int _minutes(String time) {
    final t = AdminStore.parseTime(time);
    return t.hour * 60 + t.minute;
  }

  // Sections shown in the drawer.
  Map<String, List<_MenuItem>> get _sections => {
    'Appointments': [
      _MenuItem('All Appointments', Icons.event_note, () => const AllAppointmentsScreen()),
      _MenuItem('Manage Appointments', Icons.edit_calendar, () => const ManageAppointmentsScreen()),
    ],
    'Customers': [
      _MenuItem('All Customers', Icons.people_alt_outlined, () => const AllCustomersScreen()),
    ],
    'Services': [
      _MenuItem('Service Categories', Icons.category_outlined, () => const ManageServiceCategoriesScreen()),
      _MenuItem('Manage Services', Icons.spa_outlined, () => const ManageServicesScreen()),
    ],
    'Packages': [
      _MenuItem('Manage Packages', Icons.card_giftcard, () => const ManagePackagesScreen()),
      _MenuItem('Purchased Packages', Icons.shopping_bag_outlined, () => const AdminPurchasedPackagesScreen()),
      _MenuItem('Package Usage', Icons.fact_check_outlined, () => const PackageUsageManagementScreen()),
    ],
    'Staff': [
      _MenuItem('All Staff', Icons.badge_outlined, () => const AllStaffScreen()),
      _MenuItem('Staff Availability', Icons.schedule, () => const ManageStaffAvailabilityScreen()),
    ],
    'Payments': [
      _MenuItem('Finance Dashboard', Icons.account_balance_wallet_outlined, () => const FinanceDashboardScreen()),
      _MenuItem('All Transactions', Icons.receipt_long_outlined, () => const AllTransactionsScreen()),
      _MenuItem('Manage Payments', Icons.payments_outlined, () => const ManagePaymentsScreen()),
      _MenuItem('Refunds', Icons.assignment_return_outlined, () => const RefundManagementScreen()),
    ],
    'Content & Reports': [
      _MenuItem('Gallery', Icons.photo_library_outlined, () => const ManageGalleryScreen()),
      _MenuItem('Offers', Icons.local_offer_outlined, () => const ManageOffersScreen()),
      _MenuItem('Revenue Report', Icons.bar_chart, () => const RevenueReportScreen()),
      _MenuItem('Notifications', Icons.notifications_none, () => const NotificationHistoryScreen()),
    ],
    'Account': [
      _MenuItem('Profile', Icons.person_outline, () => const AdminProfileScreen()),
      _MenuItem('Settings', Icons.settings_outlined, () => const AdminSettingsScreen()),
    ],
  };

  Widget _drawer() {
    final children = <Widget>[
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
        color: AdminColors.blushPink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
            Text(
              AdminStore.adminName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AdminStore.adminEmail,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.dashboard_outlined, color: AdminColors.golden),
        title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: AdminColors.mocha)),
        onTap: () => Navigator.pop(context),
      ),
    ];

    _sections.forEach((section, items) {
      children.add(const Divider(height: 1));
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
        child: Text(
          section.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: AdminColors.mocha.withValues(alpha: 0.6),
          ),
        ),
      ));
      for (final item in items) {
        children.add(ListTile(
          dense: true,
          leading: Icon(item.icon, color: AdminColors.golden, size: 22),
          title: Text(item.title, style: const TextStyle(color: AdminColors.mocha)),
          onTap: () {
            Navigator.pop(context);
            _go(item.page());
          },
        ));
      }
    });

    children.add(const Divider(height: 1));
    children.add(ListTile(
      leading: const Icon(Icons.logout, color: AdminColors.red),
      title: const Text('Logout', style: TextStyle(color: AdminColors.red)),
      onTap: () => adminLogout(context),
    ));

    return Drawer(
      backgroundColor: AdminColors.cream,
      child: ListView(padding: EdgeInsets.zero, children: children),
    );
  }

  Widget _quickAction(String label, IconData icon, Widget Function() page) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _go(page()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AdminColors.softBeige),
            ),
            child: Icon(icon, color: AdminColors.blushPink, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: AdminColors.mocha,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = AdminStore.today();
    final appts = AdminStore.appointments;

    final todays = appts
        .where((a) =>
    AdminStore.sameDay(a.date, today) && a.status != 'Cancelled')
        .toList()
      ..sort((a, b) => _minutes(a.time).compareTo(_minutes(b.time)));

    final pendingAppts = appts.where((a) => a.status == 'Pending').length;
    final recent = AdminStore.transactions.take(3).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      drawer: _drawer(),
      appBar: AdminUi.appBar(
        'Admin Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _go(const NotificationHistoryScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => _go(const AdminProfileScreen()),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AdminColors.blushPink,
        onRefresh: () async => setState(() {}),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            // Greeting
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AdminColors.blushPink, Color(0xFFD98BA0)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${AdminStore.adminName}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AdminStore.date(DateTime.now()),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${todays.length} appointment(s) today  |  $pendingAppts awaiting approval',
                          style: const TextStyle(color: Colors.white, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.spa, color: Colors.white, size: 44),
                ],
              ),
            ),

            AdminUi.statRow(
              AdminUi.statCard(
                icon: Icons.event_available,
                label: "Today's Appointments",
                value: '${todays.length}',
                color: AdminColors.blue,
                onTap: () => _go(const ManageAppointmentsScreen()),
              ),
              AdminUi.statCard(
                icon: Icons.pending_actions,
                label: 'Pending Approval',
                value: '$pendingAppts',
                color: AdminColors.orange,
                onTap: () => _go(const ManageAppointmentsScreen()),
              ),
            ),
            AdminUi.statRow(
              AdminUi.statCard(
                icon: Icons.account_balance_wallet,
                label: 'Total Revenue',
                value: AdminStore.money(AdminStore.totalRevenue),
                color: AdminColors.green,
                onTap: () => _go(const FinanceDashboardScreen()),
              ),
              AdminUi.statCard(
                icon: Icons.hourglass_bottom,
                label: 'Pending Payments',
                value: AdminStore.money(AdminStore.pendingAmount),
                color: AdminColors.golden,
                onTap: () => _go(const ManagePaymentsScreen()),
              ),
            ),
            AdminUi.statRow(
              AdminUi.statCard(
                icon: Icons.people,
                label: 'Customers',
                value: '${AdminStore.customers.length}',
                onTap: () => _go(const AllCustomersScreen()),
              ),
              AdminUi.statCard(
                icon: Icons.badge,
                label: 'Active Staff',
                value: '${AdminStore.activeStaff.length}',
                color: AdminColors.mocha,
                onTap: () => _go(const AllStaffScreen()),
              ),
            ),

            AdminUi.sectionTitle('Quick Actions'),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 8,
              childAspectRatio: 0.82,
              children: [
                _quickAction('Appointments', Icons.event_note, () => const AllAppointmentsScreen()),
                _quickAction('Customers', Icons.people_alt_outlined, () => const AllCustomersScreen()),
                _quickAction('Services', Icons.spa_outlined, () => const ManageServicesScreen()),
                _quickAction('Packages', Icons.card_giftcard, () => const ManagePackagesScreen()),
                _quickAction('Staff', Icons.badge_outlined, () => const AllStaffScreen()),
                _quickAction('Payments', Icons.payments_outlined, () => const ManagePaymentsScreen()),
                _quickAction('Gallery', Icons.photo_library_outlined, () => const ManageGalleryScreen()),
                _quickAction('Offers', Icons.local_offer_outlined, () => const ManageOffersScreen()),
                _quickAction('Refunds', Icons.assignment_return_outlined, () => const RefundManagementScreen()),
                _quickAction('Reports', Icons.bar_chart, () => const RevenueReportScreen()),
                _quickAction('Notify', Icons.campaign_outlined, () => const NotificationHistoryScreen()),
                _quickAction('Settings', Icons.settings_outlined, () => const AdminSettingsScreen()),
              ],
            ),

            const SizedBox(height: 8),
            AdminUi.sectionTitle(
              "Today's Schedule",
              trailing: TextButton(
                onPressed: () => _go(const AllAppointmentsScreen()),
                child: const Text('See all',
                    style: TextStyle(color: AdminColors.blushPink)),
              ),
            ),
            if (todays.isEmpty)
              AdminUi.card(
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('No appointments scheduled for today',
                        style: TextStyle(color: AdminColors.mocha)),
                  ),
                ),
              )
            else
              ...todays.take(5).map(
                    (a) => AdminUi.card(
                  onTap: () => _go(AppointmentsDetailScreen(appointment: a)),
                  child: Row(
                    children: [
                      AdminUi.thumb(a.image, size: 50),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.service,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.mocha)),
                            const SizedBox(height: 2),
                            Text('${a.customerName}  •  ${a.time}',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.75))),
                          ],
                        ),
                      ),
                      AdminUi.statusChip(a.status),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 8),
            AdminUi.sectionTitle(
              'Recent Transactions',
              trailing: TextButton(
                onPressed: () => _go(const AllTransactionsScreen()),
                child: const Text('See all',
                    style: TextStyle(color: AdminColors.blushPink)),
              ),
            ),
            ...recent.map(
                  (t) => AdminUi.card(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AdminColors.softBeige,
                      child: Icon(Icons.receipt_long, color: AdminColors.mocha),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.service,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AdminColors.mocha)),
                          Text('${t.customerName}  •  ${t.method}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color:
                                  AdminColors.mocha.withValues(alpha: 0.75))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(AdminStore.money(t.amount),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AdminColors.mocha)),
                        const SizedBox(height: 4),
                        AdminUi.statusChip(t.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
