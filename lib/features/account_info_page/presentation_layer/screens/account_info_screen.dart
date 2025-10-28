import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_event.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_state.dart';

import 'package:lingo_sign/features/account_info_page/presentation_layer/widgits/custom_info_feild.dart';

// ignore: must_be_immutable
class AccountInfoScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.h),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Account information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.h,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<EditAccountInfoBloc, EditAccountInfoState>(
        listener: (context, state) {
          if (state is EditAccountError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AccountInfoUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          }
        },
        builder: (context, state) {
          if (state is EditAccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EditAccountLoaded) {
            nameController.text = state.name;
            phoneController.text = state.phone;
            emailController.text = state.email;
          }
          return Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomInfoFeild(
                      description: 'Full Name',
                      controller: nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your name' : null,
                    ),
                    CustomInfoFeild(
                      description: 'Phone Number',
                      controller: phoneController,
                      validator: (value) =>
                          !value!.contains('@') ? 'Enter a valid email' : null,
                    ),
                    CustomInfoFeild(
                      description: 'Email',
                      controller: emailController,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your phone number' : null,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<EditAccountInfoBloc>().add(
                            UpdateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            ),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
