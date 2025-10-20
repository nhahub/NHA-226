import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/features/auth/presentation/screen/signin_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRouter,
      home: SigninScreen(),
    );
  }
}
