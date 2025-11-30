import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/core/utils/helper.dart';
import 'package:lingo_sign/features/add_friend/presentation/cubit/friend_request_cubit.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final cubit = context.read<FriendRequestCubit>();
        showDialog(
          context: context,
          builder: (dialogContext) {
            return BlocProvider.value(
              value: cubit,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColor.white,
                content: SizedBox(
                  width: context.width - 32,
                  height: context.height / 3.5,
                  child: BlocConsumer<FriendRequestCubit, FriendRequestState>(
                    listener: (context, state) {
                      if (state is FriendRequestSuccess ||
                          state is FriendRequestError) {
                        Navigator.pop(context);
                        emailController.clear();
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          const SizedBox(height: 32),
                          const Text(
                            "Add Friend",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor.gray,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: "Enter friend email",
                              hintStyle: TextStyle(color: AppColor.gray),
                              suffixIcon: Icon(
                                Icons.email,
                                color: AppColor.gray,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          state is FriendRequestLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (emailController.text.isNotEmpty) {
                                      context
                                          .read<FriendRequestCubit>()
                                          .sendRequest(
                                            emailController.text.trim(),
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.main,
                                    fixedSize: const Size(311, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      shape: const CircleBorder(),
      backgroundColor: AppColor.main,
      child: Icon(Icons.add, color: AppColor.white),
    );
  }
}
