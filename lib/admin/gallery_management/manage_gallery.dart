import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class ManageGalleryScreen extends StatefulWidget {
  const ManageGalleryScreen({super.key});

  @override
  State<ManageGalleryScreen> createState() => _ManageGalleryScreenState();
}

class _ManageGalleryScreenState extends State<ManageGalleryScreen> {
  String _category = 'All';

  Future<void> _openForm({GalleryItem? existing}) async {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController(text: existing?.title ?? '');
    String category = existing?.category ?? AdminStore.galleryCategories.first;
    String image = existing?.image ?? AdminAssets.images.first;

    final ok = await AdminUi.formDialog(
      context,
      title: existing == null ? 'Add Gallery Image' : 'Edit Gallery Image',
      formKey: formKey,
      fields: (setState) => Column(
        children: [
          AdminUi.field(title, 'Title',
              icon: Icons.title, validator: AdminUi.validateRequired),
          AdminUi.dropdown<String>(
            value: category,
            items: AdminStore.galleryCategories,
            label: 'Category',
            icon: Icons.category_outlined,
            onChanged: (v) => setState(() => category = v ?? category),
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
        AdminStore.gallery.insert(
          0,
          GalleryItem(
            id: AdminStore.nextId('g'),
            title: title.text.trim(),
            category: category,
            image: image,
          ),
        );
      } else {
        existing.title = title.text.trim();
        existing.category = category;
        existing.image = image;
      }
    });
  }

  Future<void> _delete(GalleryItem g) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Remove image?',
      message: '"${g.title}" will be removed from the gallery.',
      confirmText: 'Remove',
      danger: true,
    );
    if (ok) setState(() => AdminStore.gallery.remove(g));
  }

  @override
  Widget build(BuildContext context) {
    final cats = ['All', ...AdminStore.galleryCategories];
    final list = AdminStore.gallery
        .where((g) => _category == 'All' || g.category == _category)
        .toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Manage Gallery'),
      floatingActionButton:
      AdminUi.fab('Add Image', Icons.add_photo_alternate_outlined, () => _openForm()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AdminUi.filterChips(
                cats, _category, (v) => setState(() => _category = v)),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No images in this category',
                icon: Icons.photo_library_outlined)
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final g = list[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        g.image,
                        fit: BoxFit.cover,
                        cacheWidth: 500,
                        errorBuilder: (c, e, s) =>
                            Container(color: AdminColors.softBeige),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(g.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              Text(g.category,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Row(
                          children: [
                            _roundIcon(Icons.edit, () => _openForm(existing: g)),
                            const SizedBox(width: 6),
                            _roundIcon(Icons.delete_outline, () => _delete(g),
                                color: AdminColors.red),
                          ],
                        ),
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

  Widget _roundIcon(IconData icon, VoidCallback onTap,
      {Color color = AdminColors.mocha}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
