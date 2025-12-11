import 'package:get_it/get_it.dart';
import 'package:lingo_sign/features/call/data/call_repository_impl.dart';
import 'package:lingo_sign/features/call/data/firebase_datasource.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // call
  getIt.registerSingleton<FirebaseDataSource>(FirebaseDataSource());
  getIt.registerSingleton<CallRepository>(
    CallRepositoryImpl(firebaseDataSource: getIt<FirebaseDataSource>()),
  );
  getIt.registerSingleton<CallBloc>(
    CallBloc(callRepository: getIt<CallRepository>()),
  );
}
