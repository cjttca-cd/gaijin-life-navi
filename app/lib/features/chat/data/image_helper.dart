import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Utility for picking and encoding images for chat upload.
///
/// Handles camera/gallery selection, resizing via [image_picker] quality
/// settings, and base64 encoding for transport.
class ImageHelper {
  ImageHelper({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Maximum image dimension (width or height) in pixels.
  static const double maxDimension = 1024;

  /// JPEG quality (0–100) used when compressing picked images.
  static const int jpegQuality = 80;

  /// Maximum allowed decoded image size in bytes (5 MB).
  static const int maxImageBytes = 5 * 1024 * 1024;

  /// Pick an image from the given [source] (camera or gallery).
  ///
  /// Returns the picked [XFile] or `null` if the user cancelled.
  /// The image is automatically resized to [maxDimension] and JPEG
  /// compressed to [jpegQuality] by [image_picker].
  Future<XFile?> pickImage(ImageSource source) async {
    return _picker.pickImage(
      source: source,
      maxWidth: maxDimension,
      maxHeight: maxDimension,
      imageQuality: jpegQuality,
    );
  }

  /// Read an [XFile] and encode it as a raw base64 string.
  ///
  /// Returns `null` if the file exceeds [maxImageBytes].
  Future<String?> encodeToBase64(XFile file) async {
    final Uint8List bytes = await file.readAsBytes();
    if (bytes.length > maxImageBytes) {
      return null;
    }
    return base64Encode(bytes);
  }

  /// Convenience: pick + encode in one call.
  ///
  /// Returns a record of `(base64String, fileName)` or `null` if the
  /// user cancelled or the image was too large.
  Future<({String base64, String name})?> pickAndEncode(
    ImageSource source,
  ) async {
    final xFile = await pickImage(source);
    if (xFile == null) return null;

    final encoded = await encodeToBase64(xFile);
    if (encoded == null) return null;

    return (base64: encoded, name: xFile.name);
  }
}
