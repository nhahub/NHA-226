import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {}

class RefreshUserProfile extends ProfileEvent {}

class UploadProfileImage extends ProfileEvent {
  final BuildContext context;

  UploadProfileImage(this.context);

  @override
  List<Object?> get props => [context];
}

class LogoutUser extends ProfileEvent {
  final BuildContext context;

  LogoutUser(this.context);

  @override
  List<Object?> get props => [context];
}
