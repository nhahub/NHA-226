import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/account_info_page/data/account_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation/screens/account_info_screen.dart';
import 'package:lingo_sign/features/home/presentation/bloc/user_info/user_info_cubit.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_event.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_state.dart';
import 'package:lingo_sign/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:lingo_sign/features/send_us/presentation/screen/send_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().getUserInfo();
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: AppColor.white,
      ),
      backgroundColor: AppColor.white,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<UserInfoCubit, UserInfoState>(
                    builder: (context, userState) {
                      if (userState is UserInfoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userState is UserInfoError) {
                        return Text(userState.message);
                      }
                      if (userState is UserInfoLoaded) {
                        // ignore: unused_local_variable
                        final info = userState.user;
                      }
                      return const SizedBox();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => context.read<ProfileBloc>().add(
                                UploadProfileImage(context),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColor.white,
                                backgroundImage:
                                    (state.imageUrl != null &&
                                        state.imageUrl!.isNotEmpty)
                                    ? NetworkImage(state.imageUrl!)
                                    : const AssetImage(
                                        'assets/images/placeholder_user.jpg',
                                      ),
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
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    size: 16,
                                  ),
                                ),
                                onPressed: () => context
                                    .read<ProfileBloc>()
                                    .add(UploadProfileImage(context)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    text: "Profile info",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  EditAccountInfoBloc(AccountRepository()),
                            ),
                          ],
                          child: const AccountInfoScreen(),
                        ),
                      ),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    text: "Help / Send us",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SendUsScreen()),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: "Logout",
                    textColor: Colors.red,
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColor.white,
                          title: const Text("Confirm Logout"),
                          content: const Text(
                            "Are you sure you want to log out?",
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        // ignore: use_build_context_synchronously
                        context.read<ProfileBloc>().add(LogoutUser(context));
                      }
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
