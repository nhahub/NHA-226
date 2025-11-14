import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingo_sign/core/const/app_color.dart';
import 'package:lingo_sign/features/add_friend/logic/cubit/friend_request_cubit.dart';

class AddFriend extends StatefulWidget {
  AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendRequestCubit, FriendRequestState>(
      listener: (context, state) {
        if(state is FriendRequestSuccess){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Friend request sent successfully!')),
          );
        } else if(state is FriendRequestError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColor.white,
                  content: Container(
                    width: 343,
                    height: 238,
                    child: Column(
                      children: [
                        SizedBox(height: 32),
                        Text(
                          "Add Friend",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: 311,
                          height: 48,
                          child: TextFormField(
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
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {},
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.main,
                            fixedSize: Size(311, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Request",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            shape: CircleBorder(),
            backgroundColor: AppColor.main,
            child: Icon(Icons.add, color: AppColor.white),
          ),
        );
      },
    );
  }
}
