import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerTestScreen extends StatefulWidget {
  const ImagePickerTestScreen({super.key});

  @override
  State<ImagePickerTestScreen> createState() => _ImagePickerTestScreenState();
}

class _ImagePickerTestScreenState extends State<ImagePickerTestScreen> {
  File? _pickedImage;
  String _result = 'Tap buttons to test image picker';

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
          _result = '✅ Gallery image picked: ${image.path}';
        });
        print('SUCCESS: Gallery image picked: ${image.path}');
        
        // Test file size check
        final int fileSize = await image.length();
        print('File size: ${fileSize ~/ 1024} KB');
        
      } else {
        setState(() {
          _result = '❌ No image selected from gallery';
        });
      }
    } catch (e) {
      setState(() {
        _result = '❌ Error picking from gallery: $e';
      });
      print('ERROR: Gallery picker failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display picked image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _pickedImage != null
                    ? Image.file(_pickedImage!, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              
              const SizedBox(height: 30),
              
              // Result text
              Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              
              const SizedBox(height: 30),
              
              // Test buttons
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('Test Image Picker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}