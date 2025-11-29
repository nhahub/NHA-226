import 'package:get_it/get_it.dart';
import 'package:lingo_sign/features/call/data/call_repository_impl.dart';
import 'package:lingo_sign/features/call/data/firebase_datasource.dart';
import 'package:lingo_sign/features/call/domain/call_repository.dart';
import 'package:lingo_sign/features/call/domain/usecases/get_call_history_usecase.dart';
import 'package:lingo_sign/features/call/domain/usecases/make_call_usecase.dart';
import 'package:lingo_sign/features/call/presentation/bloc/call_bloc.dart';


final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // call
  sl.registerSingleton<FirebaseDataSource>(FirebaseDataSource());
  sl.registerSingleton<CallRepository>(
    CallRepositoryImpl(firebaseDataSource: sl<FirebaseDataSource>()),
  );
  sl.registerSingleton<MakeCallUseCase>(
    MakeCallUseCase(repository: sl<CallRepository>()),
  );
  sl.registerSingleton<GetCallHistoryUseCase>(
    GetCallHistoryUseCase(repository: sl<CallRepository>()),
  );
  sl.registerSingleton<CallBloc>(
    CallBloc(
      makeCallUseCase: sl<MakeCallUseCase>(),
      getCallHistoryUseCase: sl<GetCallHistoryUseCase>(),
    ),
  );

  // 
}
