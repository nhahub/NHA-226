import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/request.dart';
import 'package:lingo_sign/features/home/presentation/widget/request_friend.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key});

  final List<Request> requests = [
    Request(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Today',
    ),
    Request(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: 'Today',
    ),
    Request(
      uid: '',
      name: 'Youssef.A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Yesterday',
    ),
    Request(
      uid: '',
      name: 'Omar.S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return RequestFriend(request: requests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
