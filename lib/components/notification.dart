import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  final List<Map<String, String>> notifications = const [
    // {
    //   'title': 'Attendance Alert',
    //   'subtitle': 'You were marked absent on 30th March.',
    // },
    // {
    //   'title': 'Event Reminder',
    //   'subtitle': 'Science Fair scheduled on 3rd April.',
    // },
    // {
    //   'title': 'New Message',
    //   'subtitle': 'Your class teacher sent you a message.',
    // },
    // {
    //   'title': 'App Update',
    //   'subtitle': 'New features added to the Scango app!',
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // So it doesn't scroll independently
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.notifications_active, color: Colors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['subtitle']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
