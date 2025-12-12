import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/profile/data/repositries/profile_repositry.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_event.dart';
import 'package:lingo_sign/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository})
    : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<RefreshUserProfile>(_onLoadUserProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
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

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileImageUploading());
    try {
      await profileRepository.uploadProfileImage();
      add(RefreshUserProfile());
    } catch (e) {
      emit(ProfileError("Image upload failed: $e"));
    }
  }

  Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<ProfileState> emit,
  ) async {
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
