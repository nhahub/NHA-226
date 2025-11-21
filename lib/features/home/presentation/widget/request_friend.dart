import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:timeago/timeago.dart' as timeago;

class RequestFriend extends StatelessWidget {
  const RequestFriend({
    super.key,
    required this.request,
    this.onIgnore,
    this.onAccept,
  });

  final Request request;
  final void Function()? onIgnore;
  final void Function()? onAccept;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColor.white,
                backgroundImage: request.imageUrl.isNotEmpty
                    ? NetworkImage(request.imageUrl)
                    : AssetImage('assets/images/placeholder_user.jpg'),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: context.width / 2.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeago.format(request.createdAt),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onIgnore,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.main),
                  ),
                  child: Center(
                    child: Text(
                      'Ignore',
                      style: TextStyle(color: AppColor.main),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAccept,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColor.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Accept',
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
