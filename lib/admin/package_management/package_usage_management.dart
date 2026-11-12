import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

/// With a [purchase] it records service usage for that package. Without one it
/// lists every active package so the admin can pick which one to use.
class PackageUsageManagementScreen extends StatefulWidget {
  final PurchasedPackageItem? purchase;

  const PackageUsageManagementScreen({super.key, this.purchase});

  @override
  State<PackageUsageManagementScreen> createState() =>
      _PackageUsageManagementScreenState();
}

class _PackageUsageManagementScreenState
    extends State<PackageUsageManagementScreen> {
  String? _service;
  String _staffId = '';
  String _query = '';

  List<String> _servicesFor(PurchasedPackageItem p) {
    final def = AdminStore.packageByName(p.packageName);
    final names = def == null ? <String>[] : List<String>.from(def.services);
    if (names.isEmpty) {
      names.addAll(
          AdminStore.services.where((s) => s.active).map((s) => s.name));
    }
    return names;
  }

  void _redeem(PurchasedPackageItem p) {
    final services = _servicesFor(p);
    final service = (_service != null && services.contains(_service))
        ? _service!
        : services.first;
    final staff = AdminStore.findStaff(_staffId);

    setState(() {
      AdminStore.redeemPackageService(p, service, staff?.name ?? '');
      _service = null;
    });

    AdminUi.snack(
      context,
      p.remaining == 0
          ? '$service recorded - package completed'
          : '$service recorded - ${p.remaining} remaining',
    );
  }

  Future<void> _selectPackage(PurchasedPackageItem p) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PackageUsageManagementScreen(purchase: p)),
    );
    if (mounted) setState(() {});
  }

  Widget _picker() {
    final q = _query.toLowerCase();
    final active = AdminStore.purchasedPackages.where((p) {
      if (p.currentStatus != 'Active') return false;
      return q.isEmpty ||
          p.customerName.toLowerCase().contains(q) ||
          p.packageName.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: AdminUi.searchBar('Search customer or package',
                  (v) => setState(() => _query = v)),
        ),
        Expanded(
          child: active.isEmpty
              ? AdminUi.emptyState('No active packages to manage',
              icon: Icons.fact_check_outlined)
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
            itemCount: active.length,
            itemBuilder: (context, i) {
              final p = active[i];
              return AdminUi.card(
                onTap: () => _selectPackage(p),
                child: Row(
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
                          Text('${p.remaining} of ${p.total} remaining',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AdminColors.golden)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AdminColors.mocha),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _manage(PurchasedPackageItem p) {
    final status = p.currentStatus;
    final services = _servicesFor(p);
    final selected =
    (_service != null && services.contains(_service)) ? _service : services.first;
    final staffIds = ['', ...AdminStore.activeStaff.map((s) => s.id)];
    final canRedeem = status == 'Active' && p.remaining > 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AdminUi.card(
          child: Row(
            children: [
              AdminUi.thumb(p.image, size: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.packageName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AdminColors.mocha)),
                    Text(p.customerName,
                        style: const TextStyle(
                            fontSize: 13, color: AdminColors.mocha)),
                    Text('Expires ${AdminStore.shortDate(p.expiryDate)}',
                        style: TextStyle(
                            fontSize: 12,
                            color: AdminColors.mocha.withValues(alpha: 0.7))),
                  ],
                ),
              ),
              AdminUi.statusChip(status),
            ],
          ),
        ),
        AdminUi.statRow(
          AdminUi.statCard(
              icon: Icons.check_circle_outline,
              label: 'Used',
              value: '${p.total - p.remaining}',
              color: AdminColors.green),
          AdminUi.statCard(
              icon: Icons.hourglass_empty,
              label: 'Remaining',
              value: '${p.remaining}',
              color: AdminColors.orange),
        ),
        AdminUi.sectionTitle('Record Usage'),
        if (!canRedeem)
          AdminUi.card(
            child: Text(
              status == 'Active'
                  ? 'All services in this package have been used.'
                  : 'This package is $status, so no more services can be redeemed.',
              style: const TextStyle(color: AdminColors.mocha),
            ),
          )
        else ...[
          AdminUi.dropdown<String>(
            value: selected,
            items: services,
            label: 'Service redeemed',
            icon: Icons.spa_outlined,
            onChanged: (v) => setState(() => _service = v),
          ),
          AdminUi.dropdown<String>(
            value: staffIds.contains(_staffId) ? _staffId : '',
            items: staffIds,
            label: 'Performed by',
            icon: Icons.badge_outlined,
            itemLabel: (id) =>
            id.isEmpty ? 'Not specified' : AdminStore.findStaff(id)!.name,
            onChanged: (v) => setState(() => _staffId = v ?? ''),
          ),
          AdminUi.primaryButton('REDEEM 1 SERVICE', () => _redeem(p),
              icon: Icons.done),
        ],
        AdminUi.sectionTitle('Usage Log'),
        if (p.usage.isEmpty)
          AdminUi.card(
            child: const Text('Nothing redeemed yet',
                style: TextStyle(color: AdminColors.mocha)),
          )
        else
          ...p.usage.reversed.map(
                (u) => AdminUi.card(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AdminColors.green, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.service,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AdminColors.mocha)),
                        Text(
                            '${AdminStore.date(u.date)}${u.staffName.isEmpty ? '' : '  •  ${u.staffName}'}',
                            style: TextStyle(
                                fontSize: 12,
                                color:
                                AdminColors.mocha.withValues(alpha: 0.7))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.purchase;
    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar(p == null ? 'Package Usage' : 'Record Usage'),
      body: p == null ? _picker() : _manage(p),
    );
  }
}
