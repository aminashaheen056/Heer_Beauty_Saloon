
import 'package:flutter/material.dart';

class NotificationColors {
  static const Color cream = Color(0xFFFFF8F0);
  static const Color blushPink = Color(0xFFE8A6B7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mocha = Color(0xFF6F4E37);
  static const Color golden = Color(0xFFD4AF37);
  static const Color softBeige = Color(0xFFE8DCCB);
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  String selectedFilter = 'All';

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Appointment Confirmed',
      'message':
      'Your Hair Styling appointment has been confirmed successfully.',
      'time': '10 minutes ago',
      'category': 'Appointment',
      'isRead': false,
    },
    {
      'title': 'Special Offer!',
      'message':
      'Enjoy 20% OFF on Bridal Makeup. Book your appointment today!',
      'time': '2 hours ago',
      'category': 'Offers',
      'isRead': false,
    },
    {
      'title': 'Payment Reminder',
      'message':
      'Your payment of Rs. 1500 is due at the salon.',
      'time': 'Yesterday',
      'category': 'Payment',
      'isRead': true,
    },
    {
      'title': 'Appointment Reminder',
      'message':
      'Your Facial Treatment appointment is scheduled for tomorrow.',
      'time': 'Yesterday',
      'category': 'Appointment',
      'isRead': true,
    },
    {
      'title': 'New Beauty Collection',
      'message':
      'Explore our latest hairstyles and makeup looks in the gallery.',
      'time': '2 days ago',
      'category': 'Offers',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get filteredNotifications {

    if (selectedFilter == 'All') {
      return notifications;
    }

    if (selectedFilter == 'Unread') {
      return notifications
          .where((notification) => notification['isRead'] == false)
          .toList();
    }

    return notifications
        .where((notification) =>
    notification['category'] == selectedFilter)
        .toList();
  }

  int get unreadCount {
    return notifications
        .where((notification) => notification['isRead'] == false)
        .length;
  }

  void markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: NotificationColors.cream,

      appBar: AppBar(
        backgroundColor: NotificationColors.cream,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Notifications',
          style: TextStyle(
            color: NotificationColors.mocha,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: NotificationColors.mocha,
        ),

        actions: [

          TextButton(
            onPressed: unreadCount == 0 ? null : markAllAsRead,

            child: const Text(
              'Read All',
              style: TextStyle(
                color: NotificationColors.mocha,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // Notification Summary
          Padding(
            padding: const EdgeInsets.all(18),

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: NotificationColors.blushPink,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Stay Updated!',
                    style: TextStyle(
                      color: NotificationColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'You have $unreadCount unread notifications.',
                    style: const TextStyle(
                      color: NotificationColors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters
          SizedBox(
            height: 45,

            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),

              children: [

                'All',
                'Unread',
                'Appointment',
                'Payment',
                'Offers',

              ].map((filter) {

                bool isSelected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 9),

                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,

                    selectedColor: NotificationColors.blushPink,
                    backgroundColor: NotificationColors.white,

                    labelStyle: TextStyle(
                      color: NotificationColors.mocha,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),

                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // Notification List
          Expanded(
            child: filteredNotifications.isEmpty

                ? const Center(
              child: Text(
                'No notifications found.',
                style: TextStyle(
                  color: NotificationColors.mocha,
                  fontSize: 15,
                ),
              ),
            )

                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              itemCount: filteredNotifications.length,

              itemBuilder: (context, index) {

                final notification =
                filteredNotifications[index];

                final originalIndex =
                notifications.indexOf(notification);

                bool isRead = notification['isRead'];

                return GestureDetector(
                  onTap: () {
                    markAsRead(originalIndex);
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 13),
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: isRead
                          ? NotificationColors.white
                          : const Color(0xFFFFEDF1),

                      borderRadius: BorderRadius.circular(13),

                      border: Border.all(
                        color: NotificationColors.softBeige,
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Row(
                                children: [

                                  Expanded(
                                    child: Text(
                                      notification['title'],

                                      style: const TextStyle(
                                        color: NotificationColors.mocha,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (!isRead)
                                    Container(
                                      width: 9,
                                      height: 9,

                                      decoration: const BoxDecoration(
                                        color: NotificationColors.blushPink,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                notification['message'],

                                style: const TextStyle(
                                  color: NotificationColors.mocha,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                notification['time'],

                                style: const TextStyle(
                                  color: NotificationColors.golden,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
