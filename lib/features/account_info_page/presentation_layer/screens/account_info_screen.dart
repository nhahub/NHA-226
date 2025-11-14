import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_event.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_state.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/widgits/custom_info_feild.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<EditAccountInfoBloc>().add(LoadUserData());
  }

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
            icon: Icon(Icons.edit),
            onPressed: () {
              context.read<EditAccountInfoBloc>().add(ToggleEditMode());
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocListener<EditAccountInfoBloc, EditAccountInfoState>(
        listener: (context, state) {
          if (state is EditAccountLoaded) {
            nameController.text = state.name;
            emailController.text = state.email;
            phoneController.text = state.phone;
          } else if (state is AccountInfoUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully!")),
            );
          } else if (state is EditAccountError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<EditAccountInfoBloc, EditAccountInfoState>(
          builder: (context, state) {
            if (state is EditAccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomInfoFeild(
                      description: 'Full Name',
                      controller: nameController,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                      enableToEdited: state is EditModeState && state.isEditing,
                    ),

                    CustomInfoFeild(
                      description: 'Phone Number',
                      controller: phoneController,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone' : null,
                      enableToEdited: state is EditModeState && state.isEditing,
                    ),
                    CustomInfoFeild(
                      description: 'Email',
                      controller: emailController,
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Enter valid email'
                          : null,
                      enableToEdited: state is EditModeState && state.isEditing,
                    ),
                    const SizedBox(height: 30),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff31326F),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<EditAccountInfoBloc>().add(
                              UpdateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                              ),
                            );
                            context.read<EditAccountInfoBloc>().add(
                              ToggleEditMode(),
                            );
                          }
                        },

                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
