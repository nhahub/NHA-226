import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/profile/data/model/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final String? imageUrl;

  ProfileLoaded(this.user, this.imageUrl);

  @override
  List<Object?> get props => [user, imageUrl];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileImageUploading extends ProfileState {}

class ProfileLoggedOut extends ProfileState {}