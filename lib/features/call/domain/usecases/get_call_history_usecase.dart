import 'package:dartz/dartz.dart';
import 'package:lingo_sign/features/call/domain/call_entity.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';


class GetCallHistoryUseCase {
  final CallRepository repository;
  GetCallHistoryUseCase({required this.repository});

  Future<Either<Exception, List<CallEntity>>> call() async {
    return await repository.getCallHistory();
  }
}
