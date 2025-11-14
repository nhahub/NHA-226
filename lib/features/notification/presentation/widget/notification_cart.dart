import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lingo_sign/features/notification/domain/app_notification.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onAccept;
  final VoidCallback? onIgnore;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onAccept,
    this.onIgnore,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRequest = notification.type == NotificationType.request;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeago.format(notification.createdAt),
                          style: TextStyle(color: AppColor.gray, fontSize: 13),
                        ),
                      ],
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 8, top: 4),
                        decoration: const BoxDecoration(
                          color: AppColor.main,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                if (isRequest) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onIgnore,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Ignore',
                            style: TextStyle(color: AppColor.main),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.main,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: AppColor.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon = notification.type == NotificationType.missedCall
        ? Icons.call_missed
        : Icons.person_add_alt_1;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColor.main),
    );
  }
}
