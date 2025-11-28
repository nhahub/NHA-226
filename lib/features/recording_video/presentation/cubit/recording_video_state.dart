part of 'recording_video_cubit.dart';

sealed class RecordingVideoState extends Equatable {
  const RecordingVideoState();

  @override
  List<Object> get props => [];
}

final class RecordingVideoInitial extends RecordingVideoState {}

final class RecordingVideoLoading extends RecordingVideoState {}

final class RecordingVideoLoaded extends RecordingVideoState {}

final class RecordingVideoRecording extends RecordingVideoState {}

final class RecordingVideoStopped extends RecordingVideoState {
  final String path;
  const RecordingVideoStopped(this.path);
}

final class RecordingVideoError extends RecordingVideoState {
   String? message;
  RecordingVideoError(this.message);
}
