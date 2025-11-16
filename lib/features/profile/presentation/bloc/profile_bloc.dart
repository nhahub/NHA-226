
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/profile/data/model/repositries/profile_repositry.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_event.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_state.dart';
import 'package:lingo_sign/features/profile/data/model/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<RefreshUserProfile>(_onLoadUserProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(ProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepository.loadUserProfile();
      if (user == null) {
        emit(ProfileError("User not found"));
        return;
      }
      emit(ProfileLoaded(user, user.imageUrl));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUploadProfileImage(UploadProfileImage event, Emitter<ProfileState> emit) async {
    emit(ProfileImageUploading());
    try {
      await profileRepository.uploadProfileImage();
     
      add(RefreshUserProfile());
    } catch (e) {
      emit(ProfileError("Image upload failed: $e"));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<ProfileState> emit) async {
    try {
      await profileRepository.logout();
      emit(ProfileLoggedOut());
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
        (route) => false,
      );
    } catch (e) {
      emit(ProfileError("Logout failed: $e"));
    }
  }
}