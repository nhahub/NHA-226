import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lingo_sign/features/data/settings_local_data.dart';

class SettingsController {
  final SettingsLocalData _local = SettingsLocalData();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<bool> loadDarkMode() => _local.getDarkMode();
  Future<bool> loadNotifications() => _local.getNotifications();

  Future<void> saveDarkMode(bool value) => _local.setDarkMode(value);
  Future<void> saveNotifications(bool value) => _local.setNotifications(value);

  Future<AuthorizationStatus> getPermissionStatus() async {
    return await _messaging.getNotificationSettings().then(
      (settings) => settings.authorizationStatus
    );
  }

  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true, 
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      print("Error requesting permission: $e");
      return false;
    }
  }

  Future<void> enableNotifications() async {
    try {
     
      String? token = await _messaging.getToken();
      print("FCM Token: $token");
      
      
      await _messaging.subscribeToTopic("all_users");
      
     
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Foreground message: ${message.notification?.title}");
      });
    } catch (e) {
      print("Error enabling notifications: $e");
      throw e;
    }
  }

  Future<void> disableNotifications() async {
    try {
      await _messaging.unsubscribeFromTopic("all_users");
    
    
    } catch (e) {
      print("Error disabling notifications: $e");
      throw e;
    }
  }

 
  Future<Map<String, dynamic>> getNotificationStatus() async {
    final settings = await _messaging.getNotificationSettings();
    final isSubscribed = await loadNotifications();
    
    return {
      'permission': settings.authorizationStatus,
      'savedPreference': isSubscribed,
      'isEnabled': isSubscribed && 
          (settings.authorizationStatus == AuthorizationStatus.authorized ||
           settings.authorizationStatus == AuthorizationStatus.provisional),
    };
  }

  Future<void> initializeLocalNotifications() async {}
} 