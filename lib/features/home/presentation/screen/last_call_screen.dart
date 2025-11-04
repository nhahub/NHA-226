import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/friend.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call_card.dart';

class LastCallScreen extends StatelessWidget {
  LastCallScreen({super.key});

  final List<Friend> friends = [
    Friend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Today',
      isFavourite: false,
    ),
    Friend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: 'Today',

      isFavourite: false,
    ),
    Friend(
      uid: '',
      name: 'Youssef.A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Yesterday',

      isFavourite: false,
    ),
    Friend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Today',
      isFavourite: true,
    ),
    Friend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: 'Today',

      isFavourite: true,
    ),
    Friend(
      uid: '',
      name: 'Youssef.A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Yesterday',

      isFavourite: true,
    ),
    Friend(
      uid: '',
      name: 'Omar.S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: '2 days ago',
      isFavourite: true,
    ),
    Friend(
      uid: '',
      name: 'Omar.S',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: '2 days ago',
      isFavourite: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: const Text(
                "Favourites",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  if (friends[index].isFavourite) {
                    return FavouriteUser(userFavourite: friends[index]);
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: const Text(
                "Last Calls",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return FriendUserCallCard(userFriend: friends[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
