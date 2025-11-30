part of 'upload_cubit.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

final class UploadInitial extends UploadState {}

final class UploadLoading extends UploadState {}

final class UploadLoaded extends UploadState {
  final String path;
  const UploadLoaded(this.path);
}

final class UploadErorr extends UploadState {
  final String? message;
  const UploadErorr(this.message);
}
