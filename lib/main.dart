import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingo_sign/features/account_info_page/data_layer/account_repository.dart';
import 'package:lingo_sign/features/account_info_page/presentation_layer/bloc/edit_account_info_bloc.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'package:lingo_sign/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              EditAccountInfoBloc(AccountRepository(firestore, auth)),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/profile/account_info',
        onGenerateRoute: AppRouter().generateRouter,
      ),
    );
  }
}
