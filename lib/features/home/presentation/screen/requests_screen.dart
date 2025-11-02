import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lingo_sign/core/const/app_color.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key});
  final List<Map<String, dynamic>> favourites = [
    {
      "name": "Ahmed.H",
      "image":
          "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?w=500",
    },
    {
      "name": "Omar.S",
      "image":
          "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=500",
    },
    {
      "name": "Youssef.A",
      "image":
          "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500",
    },
    {
      "name": "Zeina.M",
      "image":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=500",
    },
    {
      "name": "Yassmine.Y",
      "image":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=500",
    },
  ];

  final List<Map<String, dynamic>> friends = [
    {
      "name": "Ahmed.H",
      "image":
          "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500",
      "lastSeen": "Today",
    },
    {
      "name": "Omar.S",
      "image":
          "https://images.unsplash.com/photo-1552058544-f2b08422138a?w=500",
      "lastSeen": "Yesterday",
    },
    {
      "name": "Youssef.A",
      "image":
          "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?w=500",
      "lastSeen": "2 days ago",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Requests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    friend["image"],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friend["name"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      friend["lastSeen"],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 95,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: AppColor.main,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      "Ignore",
                                      style: TextStyle(color: AppColor.black),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.main,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
