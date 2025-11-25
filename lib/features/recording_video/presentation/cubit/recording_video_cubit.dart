import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lingo_sign/features/recording_video/domain/recording_video_repository.dart';

part 'recording_video_state.dart';

class RecordingVideoCubit extends Cubit<RecordingVideoState> {
  final RecordingVideoRepository repository;

  RecordingVideoCubit(this.repository) : super(RecordingVideoInitial());

  Future<void> init() async {
    emit(RecordingVideoLoading());
    await repository.init();

    // IMPORTANT: اتأكد إن الكاميرا اتجاهزت فعلًا
  if (!repository.controller.value.isInitialized) {
    await Future.delayed(Duration(milliseconds: 200));
  }
  
    emit(RecordingVideoReady());
  }

  Future<void> start() async {
    try {
      await repository.startRecording();
      emit(RecordingVideoRecording());
    } catch (e) {
      emit(RecordingVideoError(e.toString()));
    }
  }

  Future<void> stop() async {
    try {
      final path = await repository.stopRecording();
      emit(RecordingVideoStopped(path));
    } catch (e) {
      emit(RecordingVideoError(e.toString()));
    }
  }
}
