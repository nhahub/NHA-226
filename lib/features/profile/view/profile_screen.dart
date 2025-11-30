import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/const/screen_name.dart';
import 'package:lingo_sign/core/widget/message.dart';
import 'package:lingo_sign/features/auth/presentation/bloc/auth_bloc.dart';
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
  bool _isLoading = false;

  void _showLogoutConfirmation(BuildContext context, void Function() onAccept) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: AppColor.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAccept();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
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
    if (_isLoading) return;
    _isLoading = true;
    try {
      final userData = await controller.getUserData();
      if (mounted) {
        setState(() {
          _currentUser = userData;
          _currentImageUrl = userData?.imageUrl;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Message(context: context, message: 'Error: $e');
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColor.white,
                              backgroundImage: _getProfileImage(),
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
                                      color: AppColor.white,
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentUser!.email,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColor.darkGray),
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
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ProfileMenuItem(
                        icon: Icons.logout,
                        text: "Logout",
                        textColor: Colors.red,
                        onTap: () => _showLogoutConfirmation(context, () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            loginScreen,
                            (context) => false,
                          );
                        }),
                      );
                    },
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
