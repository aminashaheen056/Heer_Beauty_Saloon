import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  String _category = 'All';
  String _query = '';

  Future<void> _openForm({ServiceItem? existing}) async {
    if (AdminStore.categories.isEmpty) {
      AdminUi.snack(context, 'Create a service category first');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: existing?.name ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');
    final price = TextEditingController(
        text: existing == null ? '' : '${existing.price}');
    final duration = TextEditingController(
        text: existing == null ? '' : '${existing.durationMinutes}');

    final categoryNames = AdminStore.categories.map((c) => c.name).toList();
    String category = existing != null && categoryNames.contains(existing.category)
        ? existing.category
        : categoryNames.first;
    String image = existing?.image ?? AdminAssets.images.first;

    final ok = await AdminUi.formDialog(
      context,
      title: existing == null ? 'Add Service' : 'Edit Service',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(name, 'Service name',
              icon: Icons.spa_outlined, validator: AdminUi.validateRequired),
          AdminUi.dropdown<String>(
            value: category,
            items: categoryNames,
            label: 'Category',
            icon: Icons.category_outlined,
            onChanged: (v) => setState(() => category = v ?? category),
          ),
          AdminUi.field(desc, 'Description',
              icon: Icons.notes,
              maxLines: 3,
              validator: AdminUi.validateRequired),
          AdminUi.field(price, 'Price (Rs.)',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: AdminUi.validateNumber),
          AdminUi.field(duration, 'Duration (minutes)',
              icon: Icons.timer_outlined,
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
        AdminStore.services.add(ServiceItem(
          id: AdminStore.nextId('s'),
          name: name.text.trim(),
          category: category,
          description: desc.text.trim(),
          price: int.parse(price.text.trim()),
          durationMinutes: int.parse(duration.text.trim()),
          image: image,
        ));
      } else {
        existing.name = name.text.trim();
        existing.category = category;
        existing.description = desc.text.trim();
        existing.price = int.parse(price.text.trim());
        existing.durationMinutes = int.parse(duration.text.trim());
        existing.image = image;
      }
    });
  }

  Future<void> _delete(ServiceItem s) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete service?',
      message: '"${s.name}" will be removed from the service list.',
      confirmText: 'Delete',
      danger: true,
    );
    if (ok) setState(() => AdminStore.services.remove(s));
  }

  @override
  Widget build(BuildContext context) {
    final cats = ['All', ...AdminStore.categories.map((c) => c.name)];
    if (!cats.contains(_category)) _category = 'All';
    final q = _query.toLowerCase();

    final list = AdminStore.services.where((s) {
      final matchesCat = _category == 'All' || s.category == _category;
      final matchesQuery = q.isEmpty || s.name.toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Manage Services'),
      floatingActionButton:
      AdminUi.fab('Add Service', Icons.add, () => _openForm()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                AdminUi.searchBar(
                    'Search services', (v) => setState(() => _query = v)),
                const SizedBox(height: 10),
                AdminUi.filterChips(
                    cats, _category, (v) => setState(() => _category = v)),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No services found', icon: Icons.spa_outlined)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final s = list[i];
                return AdminUi.card(
                  child: Row(
                    children: [
                      Opacity(
                        opacity: s.active ? 1 : 0.5,
                        child: AdminUi.thumb(s.image, size: 64),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AdminColors.mocha)),
                            Text(s.category,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AdminColors.golden)),
                            const SizedBox(height: 2),
                            Text(
                              '${AdminStore.money(s.price)}  •  ${AdminStore.durationText(s.durationMinutes)}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: AdminColors.mocha
                                      .withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: s.active,
                        activeTrackColor: AdminColors.blushPink,
                        onChanged: (v) => setState(() => s.active = v),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert,
                            color: AdminColors.mocha),
                        onSelected: (v) {
                          if (v == 'edit') _openForm(existing: s);
                          if (v == 'delete') _delete(s);
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
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
