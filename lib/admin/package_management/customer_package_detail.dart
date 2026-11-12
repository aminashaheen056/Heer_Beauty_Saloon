import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'package_usage_management.dart';

class CustomerPackageDetailScreen extends StatefulWidget {
  final PurchasedPackageItem purchase;

  const CustomerPackageDetailScreen({super.key, required this.purchase});

  @override
  State<CustomerPackageDetailScreen> createState() =>
      _CustomerPackageDetailScreenState();
}

class _CustomerPackageDetailScreenState
    extends State<CustomerPackageDetailScreen> {
  PurchasedPackageItem get p => widget.purchase;

  void _extend() {
    // Expired packages come back to life automatically because the status is
    // derived from the expiry date, so extend them from today.
    final base =
    p.currentStatus == 'Expired' ? AdminStore.today() : p.expiryDate;
    setState(() => p.expiryDate = base.add(const Duration(days: 7)));
    AdminUi.snack(context,
        'Validity extended by 7 days (new expiry ${AdminStore.shortDate(p.expiryDate)})');
  }

  Future<void> _cancel() async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Cancel package?',
      message:
      '${p.customerName}\'s ${p.packageName} will be cancelled and its remaining services can no longer be used. Use the refund screen if money needs to be returned.',
      confirmText: 'Cancel package',
      danger: true,
    );
    if (ok) setState(() => p.status = 'Cancelled');
  }

  Future<void> _record() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PackageUsageManagementScreen(purchase: p)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final status = p.currentStatus;
    final used = p.total - p.remaining;
    final progress = p.total == 0 ? 0.0 : used / p.total;
    final definition = AdminStore.packageByName(p.packageName);
    final usedNames = p.usage.map((u) => u.service).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Package Details'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              p.image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  Container(height: 150, color: AdminColors.softBeige),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(p.packageName,
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.mocha)),
              ),
              AdminUi.statusChip(status),
            ],
          ),
          const SizedBox(height: 12),
          AdminUi.card(
            child: Column(
              children: [
                AdminUi.infoRow(Icons.person_outline, 'Customer', p.customerName),
                AdminUi.infoRow(
                    Icons.payments_outlined, 'Price paid', AdminStore.money(p.price)),
                AdminUi.infoRow(Icons.calendar_today, 'Purchased',
                    AdminStore.date(p.purchaseDate)),
                AdminUi.infoRow(
                    Icons.event_busy, 'Expires', AdminStore.date(p.expiryDate)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AdminColors.softBeige,
                    color: AdminColors.blushPink,
                  ),
                ),
                const SizedBox(height: 6),
                Text('$used of ${p.total} services used  •  ${p.remaining} remaining',
                    style: const TextStyle(
                        fontSize: 12.5, color: AdminColors.mocha)),
              ],
            ),
          ),
          if (definition != null && definition.services.isNotEmpty) ...[
            AdminUi.sectionTitle('Included Services'),
            AdminUi.card(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: definition.services.map((s) {
                  final done = usedNames.contains(s);
                  return Chip(
                    avatar: Icon(done ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color: done ? AdminColors.green : AdminColors.mocha),
                    label: Text(s, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AdminColors.softBeige),
                  );
                }).toList(),
              ),
            ),
          ],
          AdminUi.sectionTitle('Usage History'),
          if (p.usage.isEmpty)
            AdminUi.card(
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('No services used yet',
                      style: TextStyle(color: AdminColors.mocha)),
                ),
              ),
            )
          else
            ...p.usage.reversed.map(
                  (u) => AdminUi.card(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                                  color: AdminColors.mocha
                                      .withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (status == 'Active')
            AdminUi.primaryButton('RECORD SERVICE USAGE', _record,
                icon: Icons.fact_check_outlined),
          if (status == 'Active' || status == 'Expired') ...[
            const SizedBox(height: 10),
            AdminUi.primaryButton('EXTEND VALIDITY (+7 DAYS)', _extend,
                icon: Icons.more_time, color: AdminColors.golden),
          ],
          if (status == 'Active') ...[
            const SizedBox(height: 10),
            AdminUi.primaryButton('CANCEL PACKAGE', _cancel,
                icon: Icons.cancel_outlined, color: AdminColors.red),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
