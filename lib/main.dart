import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lingo_sign/search_feature/data_layer/data_source/local_data_source.dart';
import 'package:lingo_sign/search_feature/data_layer/data_source/remote_data_source.dart';
import 'package:lingo_sign/search_feature/data_layer/repositories/search_repository.dart';
import 'package:lingo_sign/search_feature/presentation_layer/bloc/search_bloc.dart';
import 'package:lingo_sign/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  // final localDataSource = LocalDataSource(prefs);
  final remoteDataSource = RemoteDataSource(FirebaseFirestore.instance, prefs);
  final searchRepository = SearchRepository(remoteDataSource);

  runApp(MyApp(searchRepository: searchRepository));
}

class MyApp extends StatelessWidget {
  final SearchRepository searchRepository;

  const MyApp({super.key, required this.searchRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: searchRepository,
      child: BlocProvider(
        create: (_) => SearchBloc(searchRepository),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/search',
            onGenerateRoute: AppRouter().generateRouter,
          ),
        ),
      ),
    );
  }
}
