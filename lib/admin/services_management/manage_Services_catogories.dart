import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class ManageServiceCategoriesScreen extends StatefulWidget {
  const ManageServiceCategoriesScreen({super.key});

  @override
  State<ManageServiceCategoriesScreen> createState() =>
      _ManageServiceCategoriesScreenState();
}

class _ManageServiceCategoriesScreenState
    extends State<ManageServiceCategoriesScreen> {
  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('hair')) return Icons.content_cut;
    if (n.contains('make')) return Icons.brush;
    if (n.contains('nail')) return Icons.back_hand_outlined;
    if (n.contains('skin') || n.contains('facial')) return Icons.face_retouching_natural;
    return Icons.spa_outlined;
  }

  Future<void> _openForm({ServiceCategory? existing}) async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: existing?.name ?? '');
    final desc = TextEditingController(text: existing?.description ?? '');

    final ok = await AdminUi.formDialog(
      context,
      title: existing == null ? 'Add Category' : 'Edit Category',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(
            name,
            'Category name',
            icon: Icons.category_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'This field is required';
              final taken = AdminStore.categories.any((c) =>
              c != existing &&
                  c.name.toLowerCase() == v.trim().toLowerCase());
              return taken ? 'A category with this name already exists' : null;
            },
          ),
          AdminUi.field(desc, 'Description', icon: Icons.notes, maxLines: 2),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      if (existing == null) {
        AdminStore.categories.add(ServiceCategory(
          id: AdminStore.nextId('cat'),
          name: name.text.trim(),
          description: desc.text.trim(),
        ));
      } else {
        final oldName = existing.name;
        existing.name = name.text.trim();
        existing.description = desc.text.trim();
        // Keep services attached to the renamed category.
        for (final s in AdminStore.services) {
          if (s.category == oldName) s.category = existing.name;
        }
      }
    });
  }

  Future<void> _delete(ServiceCategory c) async {
    final count = AdminStore.services.where((s) => s.category == c.name).length;
    if (count > 0) {
      AdminUi.snack(context,
          'Cannot delete "${c.name}" - it still has $count service(s). Move or delete them first.');
      return;
    }
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete category?',
      message: '"${c.name}" will be removed permanently.',
      confirmText: 'Delete',
      danger: true,
    );
    if (ok) setState(() => AdminStore.categories.remove(c));
  }

  @override
  Widget build(BuildContext context) {
    final cats = AdminStore.categories;

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Service Categories'),
      floatingActionButton:
      AdminUi.fab('Add Category', Icons.add, () => _openForm()),
      body: cats.isEmpty
          ? AdminUi.emptyState('No categories yet', icon: Icons.category_outlined)
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: cats.length,
        itemBuilder: (context, i) {
          final c = cats[i];
          final count =
              AdminStore.services.where((s) => s.category == c.name).length;
          return AdminUi.card(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AdminColors.blushPink.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_iconFor(c.name),
                      color: AdminColors.blushPink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AdminColors.mocha)),
                      if (c.description.isNotEmpty)
                        Text(c.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: AdminColors.mocha
                                    .withValues(alpha: 0.7))),
                      const SizedBox(height: 2),
                      Text('$count service(s)',
                          style: const TextStyle(
                              fontSize: 12, color: AdminColors.golden)),
                    ],
                  ),
                ),
                Switch(
                  value: c.active,
                  activeTrackColor: AdminColors.blushPink,
                  onChanged: (v) => setState(() => c.active = v),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AdminColors.mocha),
                  onSelected: (v) {
                    if (v == 'edit') _openForm(existing: c);
                    if (v == 'delete') _delete(c);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
