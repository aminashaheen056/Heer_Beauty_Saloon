import 'package:flutter/material.dart';

import 'admin_store.dart';

class AdminColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const blushPink = Color(0xFFE8A6B7);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
  static const Color green = Color(0xFF2E9E6B);
  static const Color red = Color(0xFFD64545);
  static const Color orange = Color(0xFFE88A2D);
  static const Color blue = Color(0xFF3B82C4);
}

/// Images that ship with the app. The admin picks from these because the
/// project has no image-picker / storage package.
class AdminAssets {
  static const List<String> images = [
    'assets/images/hair.jpg',
    'assets/images/hair2.jpg',
    'assets/images/hair_styling.jpg',
    'assets/images/makeup.jpg',
    'assets/images/party_makup.jpg',
    'assets/images/party1.jpg',
    'assets/images/bride.jpg',
    'assets/images/bridal1.jpg',
    'assets/images/bridal2.jpg',
    'assets/images/bridal3.jpg',
    'assets/images/nail.jpg',
    'assets/images/nail1.jpg',
    'assets/images/nail2.jpg',
    'assets/images/nail3.jpg',
    'assets/images/nail4.jpg',
    'assets/images/nail5.jpg',
    'assets/images/nail_art.jpg',
    'assets/images/facial.jpg',
    'assets/images/facial1.jpg',
    'assets/images/salon.jpg',
  ];
}

class AdminUi {
  AdminUi._();

  // ---------------- Scaffold pieces ----------------
  static AppBar appBar(String title,
      {List<Widget>? actions, PreferredSizeWidget? bottom}) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: AdminColors.mocha,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AdminColors.cream,
      elevation: 0,
      iconTheme: const IconThemeData(color: AdminColors.mocha),
      actions: actions,
      bottom: bottom,
    );
  }

  static Widget fab(String label, IconData icon, VoidCallback onPressed) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AdminColors.blushPink,
      foregroundColor: Colors.white,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  static void snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AdminColors.mocha,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ---------------- Colors ----------------
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
      case 'active':
      case 'approved':
      case 'confirmed':
      case 'available':
        return AdminColors.green;
      case 'pending':
        return AdminColors.orange;
      case 'upcoming':
        return AdminColors.blue;
      case 'refunded':
        return AdminColors.golden;
      default:
        return AdminColors.red; // cancelled, rejected, failed, expired...
    }
  }

  // ---------------- Cards & chips ----------------
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(14),
    EdgeInsetsGeometry margin = const EdgeInsets.only(bottom: 12),
    VoidCallback? onTap,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminColors.softBeige),
        boxShadow: [
          BoxShadow(
            color: AdminColors.mocha.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }

  static Widget statusChip(String status) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget sectionTitle(String text, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AdminColors.mocha,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  static Widget statCard({
    required IconData icon,
    required String label,
    required String value,
    Color color = AdminColors.blushPink,
    VoidCallback? onTap,
  }) {
    return card(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AdminColors.mocha,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AdminColors.mocha.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  static Widget statRow(Widget a, Widget b) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      ),
    );
  }

  static Widget infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AdminColors.golden),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AdminColors.mocha.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AdminColors.mocha,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyState(String message, {IconData icon = Icons.inbox_outlined}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AdminColors.softBeige),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AdminColors.mocha.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget thumb(String path, {double size = 56, double radius = 12}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: size,
          height: size,
          color: AdminColors.softBeige,
          child: const Icon(Icons.image_outlined, color: AdminColors.mocha),
        ),
      ),
    );
  }

  static Widget primaryButton(
      String label,
      VoidCallback? onPressed, {
        IconData? icon,
        Color color = AdminColors.blushPink,
      }) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.check, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static Widget smallButton(
      String label,
      VoidCallback onPressed, {
        Color color = AdminColors.blushPink,
        bool outlined = false,
      }) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.5)),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12.5)),
    );
  }

  // ---------------- Inputs ----------------
  static InputDecoration inputDecoration(String label,
      {IconData? icon, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: AdminColors.mocha),
      prefixIcon: icon == null ? null : Icon(icon, color: AdminColors.golden),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AdminColors.softBeige),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AdminColors.softBeige),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AdminColors.blushPink, width: 1.6),
      ),
    );
  }

  static String? validateRequired(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  static String? validateNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    final n = int.tryParse(v.trim());
    if (n == null || n <= 0) return 'Enter a valid number';
    return null;
  }

  static String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email address';
  }

  static Widget field(
      TextEditingController controller,
      String label, {
        IconData? icon,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        int maxLines = 1,
        bool obscure = false,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: obscure ? 1 : maxLines,
        obscureText: obscure,
        validator: validator,
        decoration: inputDecoration(label, icon: icon, hint: hint),
      ),
    );
  }

  static Widget dropdown<T>({
    required T? value,
    required List<T> items,
    required String label,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabel,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: inputDecoration(label, icon: icon),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            isDense: true,
            dropdownColor: Colors.white,
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                value: e,
                child: Text(
                  itemLabel != null ? itemLabel(e) : e.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  static Widget searchBar(String hint, ValueChanged<String> onChanged) {
    final base = inputDecoration('', icon: Icons.search);
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: base.prefixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: base.border,
        enabledBorder: base.enabledBorder,
        focusedBorder: base.focusedBorder,
      ),
    );
  }

  static Widget filterChips(
      List<String> options,
      String selected,
      ValueChanged<String> onSelected,
      ) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final o = options[i];
          final isSel = o == selected;
          return ChoiceChip(
            label: Text(o),
            selected: isSel,
            onSelected: (_) => onSelected(o),
            selectedColor: AdminColors.blushPink,
            backgroundColor: Colors.white,
            side: const BorderSide(color: AdminColors.softBeige),
            labelStyle: TextStyle(
              color: isSel ? Colors.white : AdminColors.mocha,
              fontWeight: FontWeight.w600,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  // ---------------- Dialogs ----------------
  static Future<bool> confirm(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = 'Confirm',
        bool danger = false,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.cream,
        title: Text(title,
            style: const TextStyle(
                color: AdminColors.mocha, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: AdminColors.mocha)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AdminColors.mocha)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: danger ? AdminColors.red : AdminColors.blushPink,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a form inside a dialog. [fields] is rebuilt with the dialog's own
  /// setState, so dropdowns / image pickers can update live.
  static Future<bool> formDialog(
      BuildContext context, {
        required String title,
        required GlobalKey<FormState> formKey,
        required Widget Function(StateSetter setState) fields,
        String confirmText = 'Save',
      }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AdminColors.cream,
          title: Text(title,
              style: const TextStyle(
                  color: AdminColors.mocha, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: fields(setState),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel',
                  style: TextStyle(color: AdminColors.mocha)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.blushPink,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  /// Lets the admin change the login password. Returns true when changed.
  static Future<bool> changePasswordDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final current = TextEditingController();
    final next = TextEditingController();
    final confirm = TextEditingController();

    final ok = await formDialog(
      context,
      title: 'Change Password',
      formKey: formKey,
      confirmText: 'Update',
      fields: (setState) => Column(
        children: [
          field(current, 'Current password',
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) => v == AdminStore.adminPassword
                  ? null
                  : 'Current password is incorrect'),
          field(next, 'New password',
              icon: Icons.lock_reset,
              obscure: true,
              validator: (v) => (v == null || v.length < 8)
                  ? 'Use at least 8 characters'
                  : null),
          field(confirm, 'Confirm new password',
              icon: Icons.lock_reset,
              obscure: true,
              validator: (v) =>
              v == next.text ? null : 'Passwords do not match'),
        ],
      ),
    );
    if (ok) AdminStore.adminPassword = next.text;
    return ok;
  }

  static Future<DateTime?> pickDate(BuildContext context, DateTime initial,
      {DateTime? first, DateTime? last}) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first ?? DateTime(2024),
      lastDate: last ?? DateTime(2030),
    );
  }

  static Future<String?> pickTime(BuildContext context, String current) async {
    final t = await showTimePicker(
      context: context,
      initialTime: AdminStore.parseTime(current),
    );
    if (t == null) return null;
    return AdminStore.formatTime(t);
  }
}

/// Thumbnail + "Choose image" button that opens a grid of bundled images.
class AdminImagePicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AdminImagePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AdminColors.cream,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose an image',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.mocha,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: AdminAssets.images.length,
                  itemBuilder: (context, i) {
                    final path = AdminAssets.images[i];
                    final selected = path == value;
                    return GestureDetector(
                      onTap: () => Navigator.pop(ctx, path),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AdminColors.blushPink
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.asset(
                            path,
                            fit: BoxFit.cover,
                            cacheWidth: 240,
                            errorBuilder: (c, e, s) => Container(
                              color: AdminColors.softBeige,
                              child: const Icon(Icons.image_outlined),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = value.split('/').last;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          AdminUi.thumb(value, size: 60),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AdminColors.mocha, fontSize: 13),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _open(context),
            icon: const Icon(Icons.photo_library_outlined, size: 18),
            label: const Text('Change'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AdminColors.mocha,
              side: const BorderSide(color: AdminColors.golden),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple vertical bar chart (no chart package needed).
class AdminBarChart extends StatelessWidget {
  final List<MapEntry<String, int>> data;
  final double height;

  const AdminBarChart({super.key, required this.data, this.height = 140});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.fold<int>(0, (m, e) => e.value > m ? e.value : m);
    return SizedBox(
      height: height + 34,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((e) {
          final ratio = maxValue == 0 ? 0.0 : e.value / maxValue;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: (height * ratio).clamp(3.0, height),
                    decoration: BoxDecoration(
                      color: e.value == 0
                          ? AdminColors.softBeige
                          : AdminColors.blushPink,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                          fontSize: 10.5, color: AdminColors.mocha),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Horizontal labelled bars, e.g. revenue by category.
class AdminHBars extends StatelessWidget {
  final Map<String, int> data;
  final Color color;

  const AdminHBars({super.key, required this.data, this.color = AdminColors.golden});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('No data for this period',
            style: TextStyle(color: AdminColors.mocha)),
      );
    }
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = entries.first.value == 0 ? 1 : entries.first.value;
    return Column(
      children: entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(e.key,
                        style: const TextStyle(
                            fontSize: 13, color: AdminColors.mocha)),
                  ),
                  Text(AdminStore.money(e.value),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.mocha)),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: e.value / maxValue,
                  minHeight: 8,
                  backgroundColor: AdminColors.softBeige,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
