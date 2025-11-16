import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingo_sign/features/profile/data/model/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();

  Future<UserModel?> loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!, user.uid);
    } catch (e) {
      throw Exception("Failed to load user: $e");
    }
  }

  Future<String?> uploadProfileImage() async {
    try {
      final statuses = await [Permission.photos, Permission.storage].request();

      if (statuses[Permission.photos] != PermissionStatus.granted &&
          statuses[Permission.storage] != PermissionStatus.granted) {
        throw Exception("Storage permission denied");
      }

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return null;

      final File file = File(image.path);
      final user = _auth.currentUser;
      if (user == null) return null;

      final fileName = "${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";

      await supabase.storage.from('images').upload(
            fileName,
            file,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = supabase.storage.from('images').getPublicUrl(fileName);
      final finalUrl = "$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}";

      await _firestore.collection('users').doc(user.uid).update({
        "image_url": finalUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      return finalUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }
}