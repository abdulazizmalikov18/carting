import 'dart:io';
import 'dart:convert';
import 'package:carting/utils/log_service.dart';
import 'package:mime/mime.dart'; // pubspec.yaml ga qo'shing: mime: ^1.0.4

class ImageConverter {
  /// Faylni Data URI formatida base64 ga o'zgartirish
  /// Natija: "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
  static Future<String?> convertFileToBase64(File? file) async {
    if (file == null) {
      return null;
    }

    try {
      final bytes = File(file.path).readAsBytesSync();

      String img64 = base64Encode(bytes);

      return img64;
    } catch (e) {
      Log.e('Error while converting to base64: $e');
      return null;
    }
  }

  /// Faqat base64 string (Data URI prefiksiz)
  static Future<String?> convertFileToBase64Only(File? file) async {
    if (file == null) {
      return null;
    }

    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      Log.e('Error while converting to base64: $e');
      return null;
    }
  }

  /// MIME type va base64 ni alohida qaytarish
  static Future<Map<String, String>?> convertFileToBase64WithMime(
    File? file,
  ) async {
    if (file == null) {
      return null;
    }

    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

      return {
        'mimeType': mimeType,
        'base64': base64String,
        'dataUri': 'data:$mimeType;base64,$base64String',
      };
    } catch (e) {
      Log.e('Error while converting to base64: $e');
      return null;
    }
  }
}
