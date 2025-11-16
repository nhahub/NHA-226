import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lingo_sign/features/auth/presentation/screen/login_screen.dart';
import 'package:lingo_sign/features/profile/model/user_model.dart';
import 'package:lingo_sign/features/profile/view/profile_screen.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();

  /*Future<UserModel?> getUserData() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print(" No user logged in");
      return null;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      print(" No user document found for UID: ${user.uid}");
      return null;
    }

    final data = doc.data()!;
    print(" User data from Firestore: $data");
    print(" Image URL from Firestore: ${data['imageUrl']}");

    
    return UserModel.fromMap(data, user.uid);
    
  } catch (e) {
    debugPrint(' Error getting user data: $e');
    return null;
  }
}*/



  
   Future<UserModel?> getUserData() async {   
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print(' getting first user from Firestore');
        final snapshot = await _firestore.collection('users').limit(1).get();  //until merge development
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        return UserModel.fromMap(doc.data(), doc.id);
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, user.uid);
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }
  
  /*Future<UserModel?> getUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  
  if (doc.exists) {
    final data = doc.data()!;
    print("User data from Firestore: ${data['imageUrl']}");
    
   
    return UserModel.fromMap(doc.id as Map<String, dynamic>, data as String);
    
    
    // return UserModel.fromMap(data);
  }
  
  return null;
}*/


   /*Future<UserModel?> getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!, user.uid);
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  } */

Future<void> pickAndUploadImage(BuildContext context, Function refreshUI) async {
  print("Pick image tapped");

  try {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
    ].request();

    if (statuses[Permission.photos] != PermissionStatus.granted &&
        statuses[Permission.storage] != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required")),
      );
      return;
    }

    print("Picking Image...");
    
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    ).catchError((error) {
      debugPrint("Image picker error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $error")),
      );
      return null;
    });

    if (image == null) {
      print("No image selected!");
      return;
    }

    final int fileSize = await image.length();
    const int maxSizeInBytes = 2 * 1024 * 1024;

    if (fileSize > maxSizeInBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image size must be less than 2MB")),
      );
      return;
    }

    print("Image Selected: ${image.name}");
    print("Image path: ${image.path}");

    final File file = File(image.path);
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected file doesn't exist")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final String fileName;
    
    if (user != null) {
      fileName = "${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    } else {
      fileName = "guest_${DateTime.now().millisecondsSinceEpoch}.jpg";
    }

    print("Uploading to Supabase...");
    try {
      await supabase.storage
          .from('images')
          .upload(fileName, file, fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ));

      
      final String publicUrl = supabase.storage
          .from('images')
          .getPublicUrl(fileName);

      print("Upload successful! Public URL: $publicUrl");

      
      final String publicUrlWithTimestamp = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      print("Public URL with timestamp: $publicUrlWithTimestamp");

      
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          "image_url": publicUrlWithTimestamp,  
          "updatedAt": FieldValue.serverTimestamp(),
        });
        
        print("Firestore updated with image URL");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully!")),
      );

      
      await Future.delayed(const Duration(milliseconds: 1000));
      refreshUI();

   
      Future.delayed(const Duration(seconds: 2), () {
        refreshUI();
      });

    } catch (uploadError) {
      debugPrint("Supabase upload error: $uploadError");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $uploadError")),
      );
    }
    
  } catch (e) {
    debugPrint("Overall error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

 

  void onProfileInfoTap(BuildContext context) {
    _showSnackBar(context, 'Profile Info tapped');
  }

  void onHelpTap(BuildContext context) {
    _showSnackBar(context, 'Help / Send us tapped');
  }

  Future<void> onLogoutTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LogInScreen()),
        (route) => false,
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor:
            isDark ? Colors.grey[900] : const Color.fromARGB(255, 230, 230, 230),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
