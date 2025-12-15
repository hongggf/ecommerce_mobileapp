import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return file != null ? File(file.path) : null;
  }

  static Future<File?> pickFromCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    return file != null ? File(file.path) : null;
  }
}