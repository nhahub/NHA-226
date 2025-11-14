import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/features/profile/controller/settings_controller.dart';
import 'package:lingo_sign/features/profile/view/profile_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'package:lingo_sign/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SettingsController _settingsController = SettingsController();

  Future<void> _initializeNotifications() async {
    await _settingsController.initializeLocalNotifications();
  }


  await Supabase.initialize(
    url: "https://idfzqftyfepzfypxwmst.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZnpxZnR5ZmVwemZ5cHh3bXN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxODcwNTYsImV4cCI6MjA3Nzc2MzA1Nn0.ZfK-hPdoQ3S_Wxr7zNzjKRdHX7Kdq8MXmKZudHoI7Pc",
  );
  
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('darkMode') ?? false;

  runApp(MyApp(
    appRouter: AppRouter(),
    isDarkMode: isDarkMode,
  ));
}

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final bool isDarkMode;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.isDarkMode,
  });

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    requestNotificationPermission();
    _setupFirebaseMessaging();

  }

  

  void _setupFirebaseMessaging() {
  // Handle background messages
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("App opened from notification: ${message.messageId}");
  });



  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("App launched from terminated state by notification");
      
    }
  });
}




  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      sound: true,
      criticalAlert: false,
      provisional: false,
      badge: true,
    );

    print("PERMISSION STATUS >>> ${settings.authorizationStatus}");
  }

  void updateTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    setState(() => _isDarkMode = isDark);
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: widget.appRouter.generateRouter,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ProfileScreen(),
    );
  }
}