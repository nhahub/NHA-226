import 'package:dartz/dartz.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';

abstract class CallRepository {
  Future<Either<Exception, CallEntity>> makeCall({
    required String receiverId,
    bool? isVideoCall,
  });

  Future<Either<Exception, CallEntity>> joinToCall({
    required String callerId
  });

  Future<Either<Exception, void>> endTheCall({
    required String callerId,
    required String receiverId,
  });
}
