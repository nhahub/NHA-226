import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/features/friend_account/Freind.dart';
import 'package:lingo_sign/features/friend_account/Screen/freind_account_screen.dart';
// import 'package:lingo_sign/features/auth/presentation/screen/signin_screen.dart';
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
      //  home: FreindAccountScreen(userId: '7MNZhIsumBa3IqXPrZXoB6gZB9Y2',),
      home: FriendAccountScreen(
        friend: Friend(
          uid: '7MNZhIsumBa3IqXPrZXoB6gZB9Y2',
          name: 'John Doe',
          imageUrl:
              'https://www.reputationdefender.com/wp-content/uploads/2024/03/personal_branding_ideas.jpg',
          lastSeen: 'Online',
          isFavourite: false,
        ),
      ),
    );
  }
}
