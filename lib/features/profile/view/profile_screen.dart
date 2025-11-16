import 'package:flutter/material.dart';
import 'package:lingo_sign/features/profile/view/settings_screen.dart';
import 'package:lingo_sign/core/widget/custom_bottom_navigation_bar.dart';
import 'package:lingo_sign/features/profile/controller/profile_controller.dart';
import 'package:lingo_sign/features/profile/widgets/profile_menu_item.dart';
import 'package:lingo_sign/features/profile/view/account_info_screen.dart';
import 'package:lingo_sign/features/profile/view/helpUs.dart';
import 'package:lingo_sign/features/profile/model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIndex = 2;
  final controller = ProfileController();
  UserModel? _currentUser;
  String? _currentImageUrl;
  bool _isRefreshing = false;
  bool _isLoading = false;
  bool _initialLoadCompleted = false;

  void _onNavTap(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  // to show logout confirmation dialog
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
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.onLogoutTap(context);
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
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await controller.pickAndUploadImage(context, _refreshUserData);
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: _getProfileImage(),
                                child: _currentImageUrl == null || _currentImageUrl!.isEmpty
                                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              right: 0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                  child: Icon(Icons.camera_alt, color: theme.colorScheme.onPrimary, size: 20),
                                ),
                                onPressed: () async {
                                  await controller.pickAndUploadImage(context, _refreshUserData);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser!.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentUser!.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onBackground.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  Divider(color: theme.dividerColor),

                  // Menu Items
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    text: "Profile info",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountInfoScreen())),
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    text: "Help / Send us",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpUs())),
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: "Logout",
                    textColor: theme.colorScheme.error,
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                ],
              ),
            ),

      
    );
  }

  ImageProvider _getProfileImage() {
    
      return NetworkImage(_currentImageUrl!);
    
  }
}