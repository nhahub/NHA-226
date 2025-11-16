import 'package:flutter/material.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/features/profile/controller/profile_controller.dart';
import 'package:lingo_sign/features/profile/widgets/profile_menu_item.dart';
import 'package:lingo_sign/features/profile/model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = ProfileController();
  UserModel? _currentUser;
  String? _currentImageUrl;
  // bool _isRefreshing = false;
  bool _isLoading = false;
  bool _initialLoadCompleted = false;

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _refreshUserData() async {
    if (_isLoading || _initialLoadCompleted) return;

    _isLoading = true;
    print(" Starting _refreshUserData");

    try {
      final userData = await controller.getUserData();
      print(" User data received - Image URL: ${userData?.imageUrl}");

      if (mounted) {
        setState(() {
          _currentUser = userData;
          _currentImageUrl = userData?.imageUrl;
          _initialLoadCompleted = true;
          print("Profile data loaded successfully");
        });
      }
    } catch (e) {
      print(" Error in _refreshUserData: $e");
    } finally {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _refreshUserData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColor.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Profile Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await controller.pickAndUploadImage(
                                  context,
                                  _refreshUserData,
                                );
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: _getProfileImage(),
                                child:
                                    _currentImageUrl == null ||
                                        _currentImageUrl!.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: -12,
                              right: -12,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.main,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: theme.colorScheme.onPrimary,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await controller.pickAndUploadImage(
                                    context,
                                    _refreshUserData,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser!.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentUser!.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: theme.dividerColor),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    text: "Profile info",
                    onTap: () =>
                        Navigator.pushNamed(context, accountInfoScreen),
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    text: "Help / Send us",
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: "Logout",
                    textColor: theme.colorScheme.error,
                    onTap: () => _showLogoutConfirmation,
                  ),
                ],
              ),
            ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      return NetworkImage(_currentImageUrl!);
    } else {
      return const AssetImage('assets/images/placeholder_user.jpg');
    }
  }
}
