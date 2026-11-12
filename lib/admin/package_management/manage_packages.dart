import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';
import 'pakage_services.dart';

class ManagePackagesScreen extends StatefulWidget {
  const ManagePackagesScreen({super.key});

  @override
  State<ManagePackagesScreen> createState() => _ManagePackagesScreenState();
}

class _ManagePackagesScreenState extends State<ManagePackagesScreen> {
  Future<void> _openForm({PackageItem? existing}) async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: existing?.name ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');
    final price = TextEditingController(
        text: existing == null ? '' : '${existing.price}');
    final validity = TextEditingController(
        text: existing == null ? '' : '${existing.validityDays}');
    String image = existing?.image ?? AdminAssets.images.first;

    final ok = await AdminUi.formDialog(
      context,
      title: existing == null ? 'Add Package' : 'Edit Package',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(name, 'Package name',
              icon: Icons.card_giftcard, validator: AdminUi.validateRequired),
          AdminUi.field(desc, 'Description',
              icon: Icons.notes,
              maxLines: 3,
              validator: AdminUi.validateRequired),
          AdminUi.field(price, 'Price (Rs.)',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: AdminUi.validateNumber),
          AdminUi.field(validity, 'Validity (days)',
              icon: Icons.timelapse,
              keyboardType: TextInputType.number,
              validator: AdminUi.validateNumber),
          AdminImagePicker(
            value: image,
            onChanged: (v) => setState(() => image = v),
          ),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      if (existing == null) {
        AdminStore.packages.add(PackageItem(
          id: AdminStore.nextId('p'),
          name: name.text.trim(),
          description: desc.text.trim(),
          price: int.parse(price.text.trim()),
          validityDays: int.parse(validity.text.trim()),
          image: image,
          services: [],
        ));
      } else {
        existing.name = name.text.trim();
        existing.description = desc.text.trim();
        existing.price = int.parse(price.text.trim());
        existing.validityDays = int.parse(validity.text.trim());
        existing.image = image;
      }
    });
    if (existing == null && mounted) {
      AdminUi.snack(context, 'Package added - tap it to choose its services');
    }
  }

  Future<void> _delete(PackageItem p) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete package?',
      message:
      '"${p.name}" will be removed. Packages already purchased by customers are not affected.',
      confirmText: 'Delete',
      danger: true,
    );
    if (ok) setState(() => AdminStore.packages.remove(p));
  }

  void _openServices(PackageItem p) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PackageServicesScreen(package: p)),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final list = AdminStore.packages;

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Manage Packages'),
      floatingActionButton:
      AdminUi.fab('Add Package', Icons.add, () => _openForm()),
      body: list.isEmpty
          ? AdminUi.emptyState('No packages yet', icon: Icons.card_giftcard)
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final p = list[i];
          return AdminUi.card(
            padding: EdgeInsets.zero,
            onTap: () => _openServices(p),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: Opacity(
                    opacity: p.active ? 1 : 0.5,
                    child: Image.asset(
                      p.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                          height: 120, color: AdminColors.softBeige),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AdminColors.mocha)),
                          ),
                          Text(AdminStore.money(p.price),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AdminColors.blushPink)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(p.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.5,
                              color:
                              AdminColors.mocha.withValues(alpha: 0.75))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timelapse,
                              size: 15, color: AdminColors.golden),
                          const SizedBox(width: 4),
                          Text('${p.validityDays} days',
                              style: const TextStyle(
                                  fontSize: 12.5, color: AdminColors.mocha)),
                          const SizedBox(width: 14),
                          const Icon(Icons.spa_outlined,
                              size: 15, color: AdminColors.golden),
                          const SizedBox(width: 4),
                          Text('${p.services.length} services',
                              style: const TextStyle(
                                  fontSize: 12.5, color: AdminColors.mocha)),
                          const Spacer(),
                          Switch(
                            value: p.active,
                            activeTrackColor: AdminColors.blushPink,
                            onChanged: (v) => setState(() => p.active = v),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: AdminColors.mocha),
                            onSelected: (v) {
                              if (v == 'edit') _openForm(existing: p);
                              if (v == 'services') _openServices(p);
                              if (v == 'delete') _delete(p);
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                  value: 'edit', child: Text('Edit details')),
                              PopupMenuItem(
                                  value: 'services',
                                  child: Text('Manage services')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
