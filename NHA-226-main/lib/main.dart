import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/settings_screen.dart';
import 'package:lingo_sign/firebase_options.dart';
import 'package:lingo_sign/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: const SettingsScreen(),
    );
  }
}
