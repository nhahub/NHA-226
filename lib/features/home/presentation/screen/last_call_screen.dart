import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/home/domain/entities/user_favourite.dart';
import 'package:lingo_sign/features/home/domain/entities/user_friend.dart';
import 'package:lingo_sign/features/home/presentation/widget/favourite_user.dart';
import 'package:lingo_sign/features/home/presentation/widget/friend_user_call.dart';

class LastCallScreen extends StatelessWidget {
  LastCallScreen({super.key});
  final List<UserFavourite> favourites = [
    UserFavourite(
      imageUrl:
          'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?w=500',
      name: 'Ahmed.H',
    ),
    UserFavourite(
      imageUrl:
          'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=500',
      name: 'Omar.S',
    ),
    UserFavourite(
      imageUrl:
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500",
      name: 'Youssef.A',
    ),
    UserFavourite(
      imageUrl:
          'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?w=500',
      name: 'Ahmed.H',
    ),
    UserFavourite(
      imageUrl:
          'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=500',
      name: 'Omar.S',
    ),
    UserFavourite(
      imageUrl:
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500",
      name: 'Youssef.A',
    ),
  ];
  final List<UserFriend> friends = [
    UserFriend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Today',
    ),
    UserFriend(
      uid: '',
      name: 'Ahmed.H',
      imageUrl:
          'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500',
      lastSeen: 'Today',
    ),
    UserFriend(
      uid: '',
      name: 'Youssef.A',
      imageUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500',
      lastSeen: 'Yesterday',
    ),
    UserFriend(
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
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  return FavouriteUser(userFavourite: favourites[index]);
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
                    return FriendUserCall(userFriend: friends[index]);
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
