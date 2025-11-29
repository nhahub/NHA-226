import 'package:dartz/dartz.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';

class MakeCallUseCase {
  final CallRepository repository;
  MakeCallUseCase({required this.repository});

  Future<Either<Exception, CallEntity>> call({
    required String receiverId,
    required bool isVideoCall,
  }) async {
    return await repository.makeCall(
      receiverId: receiverId,
      isVideoCall: isVideoCall,
    );
  }
}
