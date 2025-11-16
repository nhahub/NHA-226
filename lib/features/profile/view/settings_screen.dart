import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lingo_sign/features/profile/view/profile_screen.dart';
import 'package:lingo_sign/main_screen.dart';
import '../../../main.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _controller = SettingsController();

  bool _isDarkMode = false;
  bool _enableNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    _isDarkMode = await _controller.loadDarkMode();
    _enableNotifications = await _controller.loadNotifications();
    setState(() {});
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      
      bool granted = await _controller.requestPermission();
      
      if (!granted) {
       
        final status = await _controller.getPermissionStatus();
        String message = _getPermissionMessage(status);
        
        _showSnackBar(message, isError: true);
        
      
        setState(() => _enableNotifications = false);
        await _controller.saveNotifications(false);
        return;
      }

     
      await _controller.enableNotifications();
      await _controller.saveNotifications(true);
      setState(() => _enableNotifications = true);
      _showSnackBar("Notifications enabled successfully!");
      
    } else {
      
      await _controller.disableNotifications();
      await _controller.saveNotifications(false);
      setState(() => _enableNotifications = false);
      _showSnackBar("Notifications disabled");
    }
  }

  String _getPermissionMessage(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.denied:
        return "Notifications denied. Enable in app settings";
      case AuthorizationStatus.provisional:
        return "Notifications set to provisional mode";
      case AuthorizationStatus.notDetermined:
        return "Notification permission not determined";
      default:
        return "Cannot enable notifications";
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : const Color.fromARGB(255, 39, 40, 89),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSettingItem(
              title: "Dark Mode",
              subtitle: "Adjust the app's visual theme",
              value: _isDarkMode,
              onChanged: (value) async {
                setState(() => _isDarkMode = value);
                await _controller.saveDarkMode(value);
                (context.findAncestorStateOfType<MyAppState>())
                    ?.updateTheme(value);
                _showSnackBar(value ? "Dark mode enabled" : "Dark mode disabled");
              },
            ),
            const SizedBox(height: 20),
            _buildSettingItem(
              title: "Enable Notifications",
              subtitle: "Receive updates and reminders",
              value: _enableNotifications,
              onChanged: _toggleNotifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  )),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 39, 40, 89),
        ),
      ],
    );
  }
}