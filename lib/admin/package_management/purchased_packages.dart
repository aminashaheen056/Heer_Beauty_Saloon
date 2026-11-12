import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'customer_package_detail.dart';

class AdminPurchasedPackagesScreen extends StatefulWidget {
  const AdminPurchasedPackagesScreen({super.key});

  @override
  State<AdminPurchasedPackagesScreen> createState() =>
      _AdminPurchasedPackagesScreenState();
}

class _AdminPurchasedPackagesScreenState
    extends State<AdminPurchasedPackagesScreen> {
  static const filters = ['All', 'Active', 'Completed', 'Expired', 'Cancelled'];

  String _filter = 'All';
  String _query = '';

  Future<void> _sellPackage() async {
    final customers = AdminStore.customers.where((c) => !c.blocked).toList();
    final packages = AdminStore.packages
        .where((p) => p.active && p.services.isNotEmpty)
        .toList();

    if (customers.isEmpty || packages.isEmpty) {
      AdminUi.snack(context,
          'You need at least one customer and one active package that has services');
      return;
    }

    final formKey = GlobalKey<FormState>();
    AdminCustomer customer = customers.first;
    PackageItem package = packages.first;
    String method = AdminStore.paymentMethods.first;

    final ok = await AdminUi.formDialog(
      context,
      title: 'Sell Package',
      formKey: formKey,
      confirmText: 'Sell',
      fields: (setState) => Column(
        children: [
          AdminUi.dropdown<AdminCustomer>(
            value: customer,
            items: customers,
            label: 'Customer',
            icon: Icons.person_outline,
            itemLabel: (c) => c.name,
            onChanged: (v) => setState(() => customer = v ?? customer),
          ),
          AdminUi.dropdown<PackageItem>(
            value: package,
            items: packages,
            label: 'Package',
            icon: Icons.card_giftcard,
            itemLabel: (p) => '${p.name} (${AdminStore.money(p.price)})',
            onChanged: (v) => setState(() => package = v ?? package),
          ),
          AdminUi.dropdown<String>(
            value: method,
            items: AdminStore.paymentMethods,
            label: 'Payment method',
            icon: Icons.payments_outlined,
            onChanged: (v) => setState(() => method = v ?? method),
          ),
          Text(
            '${package.services.length} service(s), valid for ${package.validityDays} days. The payment is recorded as Paid.',
            style: TextStyle(
                fontSize: 12, color: AdminColors.mocha.withValues(alpha: 0.75)),
          ),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.sellPackage(customer: customer, package: package, method: method);
    });
    if (mounted) {
      AdminUi.snack(context, '${package.name} sold to ${customer.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final all = AdminStore.purchasedPackages;
    final q = _query.toLowerCase();

    final list = all.where((p) {
      final matchesFilter = _filter == 'All' || p.currentStatus == _filter;
      final matchesQuery = q.isEmpty ||
          p.customerName.toLowerCase().contains(q) ||
          p.packageName.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Purchased Packages'),
      floatingActionButton:
      AdminUi.fab('Sell Package', Icons.sell_outlined, _sellPackage),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar('Search customer or package',
                        (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(
                    filters, _filter, (v) => setState(() => _filter = v)),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No purchased packages found',
                icon: Icons.shopping_bag_outlined)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final p = list[i];
                final used = p.total - p.remaining;
                final progress = p.total == 0 ? 0.0 : used / p.total;
                return AdminUi.card(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CustomerPackageDetailScreen(purchase: p)),
                  ).then((_) => setState(() {})),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AdminUi.thumb(p.image, size: 54),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.packageName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AdminColors.mocha)),
                                Text(p.customerName,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AdminColors.mocha)),
                                Text(
                                    'Expires ${AdminStore.shortDate(p.expiryDate)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AdminColors.mocha
                                            .withValues(alpha: 0.7))),
                              ],
                            ),
                          ),
                          AdminUi.statusChip(p.currentStatus),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: AdminColors.softBeige,
                          color: AdminColors.blushPink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('$used of ${p.total} services used  •  ${p.remaining} remaining',
                          style: TextStyle(
                              fontSize: 12,
                              color: AdminColors.mocha
                                  .withValues(alpha: 0.75))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
