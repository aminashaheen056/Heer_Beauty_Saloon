import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class ManageOffersScreen extends StatefulWidget {
  const ManageOffersScreen({super.key});

  @override
  State<ManageOffersScreen> createState() => _ManageOffersScreenState();
}

class _ManageOffersScreenState extends State<ManageOffersScreen> {
  Future<void> _openForm({OfferItem? existing}) async {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController(text: existing?.title ?? '');
    final discount = TextEditingController(
        text: existing == null ? '' : '${existing.discountPercent}');
    final desc = TextEditingController(text: existing?.description ?? '');
    DateTime validUntil =
        existing?.validUntil ?? AdminStore.today().add(const Duration(days: 30));
    String image = existing?.image ?? AdminAssets.images.first;

    final ok = await AdminUi.formDialog(
      context,
      title: existing == null ? 'Add Offer' : 'Edit Offer',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(title, 'Offer title',
              icon: Icons.local_offer_outlined,
              validator: AdminUi.validateRequired),
          AdminUi.field(discount, 'Discount (%)',
              icon: Icons.percent,
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n < 1 || n > 100) return 'Enter 1 to 100';
                return null;
              }),
          AdminUi.field(desc, 'Description',
              icon: Icons.notes,
              maxLines: 3,
              validator: AdminUi.validateRequired),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final d = await AdminUi.pickDate(context, validUntil);
                  if (d != null) setState(() => validUntil = d);
                },
                icon: const Icon(Icons.event, size: 18),
                label: Text('Valid until ${AdminStore.date(validUntil)}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminColors.mocha,
                  side: const BorderSide(color: AdminColors.golden),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
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
        AdminStore.offers.insert(
          0,
          OfferItem(
            id: AdminStore.nextId('o'),
            title: title.text.trim(),
            discountPercent: int.parse(discount.text.trim()),
            description: desc.text.trim(),
            validUntil: validUntil,
            image: image,
          ),
        );
      } else {
        existing.title = title.text.trim();
        existing.discountPercent = int.parse(discount.text.trim());
        existing.description = desc.text.trim();
        existing.validUntil = validUntil;
        existing.image = image;
      }
    });
  }

  Future<void> _delete(OfferItem o) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete offer?',
      message: '"${o.title}" will be removed.',
      confirmText: 'Delete',
      danger: true,
    );
    if (ok) setState(() => AdminStore.offers.remove(o));
  }

  @override
  Widget build(BuildContext context) {
    final list = AdminStore.offers;

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Manage Offers'),
      floatingActionButton:
      AdminUi.fab('Add Offer', Icons.add, () => _openForm()),
      body: list.isEmpty
          ? AdminUi.emptyState('No offers yet', icon: Icons.local_offer_outlined)
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final o = list[i];
          return AdminUi.card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Opacity(
                        opacity: o.active && !o.expired ? 1 : 0.5,
                        child: Image.asset(
                          o.image,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                              height: 130, color: AdminColors.softBeige),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AdminColors.blushPink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${o.discountPercent}% OFF',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (o.expired)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AdminUi.statusChip('Expired'),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AdminColors.mocha)),
                      const SizedBox(height: 4),
                      Text(o.description,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: AdminColors.mocha
                                  .withValues(alpha: 0.75))),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.event,
                              size: 15, color: AdminColors.golden),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                                'Valid until ${AdminStore.date(o.validUntil)}',
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AdminColors.mocha)),
                          ),
                          Switch(
                            value: o.active,
                            activeTrackColor: AdminColors.blushPink,
                            onChanged: (v) => setState(() => o.active = v),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: AdminColors.mocha),
                            onPressed: () => _openForm(existing: o),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AdminColors.red),
                            onPressed: () => _delete(o),
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
