import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  static const audiences = ['All Customers', 'Package Holders', 'Staff'];

  String _filter = 'All';

  Future<void> _send() async {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController();
    final message = TextEditingController();
    String audience = audiences.first;

    final ok = await AdminUi.formDialog(
      context,
      title: 'Send Notification',
      formKey: formKey,
      confirmText: 'Send',
      fields: (setState) => Column(
        children: [
          AdminUi.dropdown<String>(
            value: audience,
            items: audiences,
            label: 'Send to',
            icon: Icons.groups_outlined,
            onChanged: (v) => setState(() => audience = v ?? audience),
          ),
          AdminUi.field(title, 'Title',
              icon: Icons.title, validator: AdminUi.validateRequired),
          AdminUi.field(message, 'Message',
              icon: Icons.message_outlined,
              maxLines: 4,
              validator: AdminUi.validateRequired),
        ],
      ),
    );

    if (!ok) return;
    setState(() {
      AdminStore.addNotification(
          title.text.trim(), message.text.trim(), audience);
    });
    if (mounted) AdminUi.snack(context, 'Notification sent to $audience');
  }

  Future<void> _delete(AdminNotification n) async {
    final ok = await AdminUi.confirm(
      context,
      title: 'Delete notification?',
      message: 'Remove "${n.title}" from the history?',
      confirmText: 'Delete',
      danger: true,
    );
    if (ok) setState(() => AdminStore.notifications.remove(n));
  }

  String _ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    if (diff.inDays < 1) return '${diff.inHours} h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return AdminStore.date(d);
  }

  IconData _iconFor(AdminNotification n) {
    final t = n.title.toLowerCase();
    if (t.contains('refund')) return Icons.assignment_return_outlined;
    if (t.contains('appointment')) return Icons.event_note;
    if (t.contains('offer')) return Icons.local_offer_outlined;
    if (t.contains('package')) return Icons.card_giftcard;
    return Icons.notifications_none;
  }

  @override
  Widget build(BuildContext context) {
    final customerNames = AdminStore.customers.map((c) => c.name).toSet();
    final all = AdminStore.notifications;

    // Audience can be a group name or a single customer's name.
    final list = all.where((n) {
      if (_filter == 'All') return true;
      if (_filter == 'Individual') return customerNames.contains(n.audience);
      return n.audience == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar('Notification History'),
      floatingActionButton:
      AdminUi.fab('Send New', Icons.send_outlined, _send),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AdminUi.filterChips(
              ['All', ...audiences, 'Individual'],
              _filter,
                  (v) => setState(() => _filter = v),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? AdminUi.emptyState('No notifications here yet',
                icon: Icons.notifications_off_outlined)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final n = list[i];
                return AdminUi.card(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                          AdminColors.blushPink.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_iconFor(n),
                            color: AdminColors.blushPink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AdminColors.mocha)),
                            const SizedBox(height: 2),
                            Text(n.message,
                                style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: AdminColors.mocha)),
                            const SizedBox(height: 6),
                            Text('To: ${n.audience}  •  ${_ago(n.date)}',
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: AdminColors.mocha
                                        .withValues(alpha: 0.6))),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_outline,
                            color: AdminColors.red, size: 20),
                        onPressed: () => _delete(n),
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
