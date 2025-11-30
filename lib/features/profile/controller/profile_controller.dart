import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/core/widget/message.dart';
import 'package:lingo_sign/features/profile/model/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final ImagePicker imagePicker = ImagePicker();

  Future<UserModel?> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return throw Exception('User not found');
      final doc = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .get();
      return UserModel.fromMap(doc.data()!, user.uid);
    } catch (e) {
      return null;
    }
  }

  Future<void> pickAndUploadImage(
    BuildContext context,
    Function refreshUI,
  ) async {
    try {
      // Request Permission
      final statuses = await [Permission.photos, Permission.storage].request();

      if (statuses.values.every((s) => s != PermissionStatus.granted)) {
        // ignore: use_build_context_synchronously
        Message(context: context, message: "Storage permission is required");
        return;
      }

      // Pick Image
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return;

      // Validate size
      final int size = await image.length();
      if (size > 2 * 1024 * 1024) {
        // ignore: use_build_context_synchronously
        Message(context: context, message: "Image size must be less than 2MB");
        return;
      }

      final file = File(image.path);
      if (!file.existsSync()) {
        // ignore: use_build_context_synchronously
        Message(context: context, message: "Selected file doesn't exist");
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      final ts = DateTime.now().millisecondsSinceEpoch;
      final fileName = "${user?.uid ?? "guest"}_$ts.jpg";

      // Upload to Supabase
      final uploadRes = await supabase.storage
          .from('images')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      if (uploadRes.isEmpty) {
        // ignore: use_build_context_synchronously
        Message(context: context, message: "Upload failed", color: Colors.red);
        return;
      }

      final url = supabase.storage.from('images').getPublicUrl(fileName);
      final finalUrl = "$url?ts=$ts";

      // Update Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
              "image_url": finalUrl,
              "updatedAt": FieldValue.serverTimestamp(),
            });
      }

      Message(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Profile picture updated successfully!",
        color: Colors.green,
      );

      refreshUI();
    } catch (e) {
      // ignore: use_build_context_synchronously
      Message(context: context, message: "Error: $e", color: Colors.red);
    }
  }
}
