import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lingo_sign/features/call/data/firebase_datasource.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  final FirebaseDataSource firebaseDataSource;
  CallRepositoryImpl({required this.firebaseDataSource});
  
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<Exception, CallEntity>> makeCall({
    required String receiverId,
    required String receiverName,
    required bool isVideoCall,
  }) async {
    try {
      final result = await firebaseDataSource.makeCall(
        receiverId: receiverId,
        receiverName: receiverName,
        callerId: firebaseAuth.currentUser!.uid,
        callerName: firebaseAuth.currentUser?.displayName ?? 'UserName',
        isVideoCall: isVideoCall,
      );
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updateCallStatus({
    required String callId,
    required String status,
  }) async {
    try {
      await firebaseDataSource.updateCallStatus(callId, status);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Stream<CallEntity> listenToIncomingCalls(String uid) {
    return firebaseDataSource.listenToIncomingCalls(uid);
  }
}
