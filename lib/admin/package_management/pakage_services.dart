import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class PackageServicesScreen extends StatefulWidget {
  final PackageItem package;

  const PackageServicesScreen({super.key, required this.package});

  @override
  State<PackageServicesScreen> createState() => _PackageServicesScreenState();
}

class _PackageServicesScreenState extends State<PackageServicesScreen> {
  PackageItem get p => widget.package;

  int _priceOf(String name) {
    for (final s in AdminStore.services) {
      if (s.name == name) return s.price;
    }
    return 0;
  }

  Future<void> _addServices() async {
    final formKey = GlobalKey<FormState>();
    final available = AdminStore.services
        .where((s) => s.active && !p.services.contains(s.name))
        .toList();
    final selected = <String>{};
    final custom = TextEditingController();

    final ok = await AdminUi.formDialog(
      context,
      title: 'Add Services',
      formKey: formKey,
      confirmText: 'Add',
      fields: (setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (available.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('All active services are already in this package.',
                  style: TextStyle(color: AdminColors.mocha)),
            ),
          ...available.map(
                (s) => CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: AdminColors.blushPink,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(s.name,
                  style: const TextStyle(color: AdminColors.mocha)),
              subtitle: Text(
                  '${s.category}  •  ${AdminStore.money(s.price)}',
                  style: const TextStyle(fontSize: 11.5)),
              value: selected.contains(s.name),
              onChanged: (v) => setState(() {
                if (v == true) {
                  selected.add(s.name);
                } else {
                  selected.remove(s.name);
                }
              }),
            ),
          ),
          const SizedBox(height: 10),
          AdminUi.field(custom, 'Or add a custom service name',
              icon: Icons.edit_outlined),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      p.services.addAll(selected);
      final extra = custom.text.trim();
      if (extra.isNotEmpty && !p.services.contains(extra)) {
        p.services.add(extra);
      }
    });
  }

  Future<void> _remove(String name) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Remove service?',
      message: '"$name" will be removed from ${p.name}.',
      confirmText: 'Remove',
      danger: true,
    );
    if (ok) setState(() => p.services.remove(name));
  }

  @override
  Widget build(BuildContext context) {
    final separateValue =
    p.services.fold<int>(0, (sum, name) => sum + _priceOf(name));
    final saving = separateValue - p.price;

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Package Services'),
      floatingActionButton:
      AdminUi.fab('Add Services', Icons.add, _addServices),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          AdminUi.card(
            child: Row(
              children: [
                AdminUi.thumb(p.image, size: 64),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AdminColors.mocha)),
                      const SizedBox(height: 2),
                      Text(
                          '${AdminStore.money(p.price)}  •  ${p.validityDays} days validity',
                          style: TextStyle(
                              fontSize: 12.5,
                              color: AdminColors.mocha.withValues(alpha: 0.8))),
                      const SizedBox(height: 2),
                      Text('${p.services.length} included service(s)',
                          style: const TextStyle(
                              fontSize: 12, color: AdminColors.golden)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (separateValue > 0)
            AdminUi.card(
              child: Row(
                children: [
                  const Icon(Icons.savings_outlined, color: AdminColors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      saving >= 0
                          ? 'Services are worth ${AdminStore.money(separateValue)} separately - customers save ${AdminStore.money(saving)}.'
                          : 'Services are worth ${AdminStore.money(separateValue)} separately - the package costs ${AdminStore.money(-saving)} more.',
                      style: const TextStyle(
                          fontSize: 12.5, color: AdminColors.mocha),
                    ),
                  ),
                ],
              ),
            ),
          AdminUi.sectionTitle('Included Services'),
          if (p.services.isEmpty)
            AdminUi.emptyState('No services added yet.\nTap "Add Services" below.',
                icon: Icons.spa_outlined)
          else
            ...p.services.map(
                  (name) => AdminUi.card(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AdminColors.green, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AdminColors.mocha)),
                          if (_priceOf(name) > 0)
                            Text(AdminStore.money(_priceOf(name)),
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AdminColors.red),
                      onPressed: () => _remove(name),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
