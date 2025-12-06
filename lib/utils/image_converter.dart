import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carting/utils/log_service.dart';
import 'package:mime/mime.dart'; // pubspec.yaml ga qo'shing: mime: ^1.0.4
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageConverter {
  // 100 KB ga compress qiluvchi yordamchi funksiya
  static Future<Uint8List?> _compressTo100KB(File file) async {
    const targetSize = 100 * 1024; // 100 KB
    int quality = 90;

    Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
    );

    if (result == null) return null;

    while ((result?.lengthInBytes ?? 0) > targetSize && quality > 10) {
      quality -= 10;
      result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
      );
    }

    return result;
  }

  /// Faylni Data URI formatida base64 ga o'zgartirish
  /// Natija: "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
  static Future<String?> convertFileToBase64(File? file) async {
    if (file == null) return null;

    try {
      // ➤ Avval 100 KB ga compress qilamiz
      Uint8List? compressed = await _compressTo100KB(file);

      if (compressed == null) {
        Log.e("Compression failed");
        return null;
      }

      // ➤ Base64 ga o‘tkazish
      String img64 = base64Encode(compressed);

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
