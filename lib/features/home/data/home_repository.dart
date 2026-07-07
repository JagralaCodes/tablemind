import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class HomeRepository {
  Future<List<String?>> pickImagesFromCamera();
  Future<List<String?>> pickFileFromStorage();
  Future<String?> scanQRCode();
}

class HomeRepositoryImpl implements HomeRepository {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<List<String?>> pickImagesFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      return photo != null ? [photo.path] : [];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<String?>> pickFileFromStorage() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'jpg',
          'png',
          'jpeg',
          'md',
          'json',
        ],
      );

      if (result == null) return [];

      final paths = result.files
          .map((e) => e.path)
          .whereType<String>()
          .toList();

      List<String> images = [];
      List<String> docs = [];

      for (var path in paths) {
        final lower = path.toLowerCase();
        if (lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png')) {
          images.add(path);
        } else {
          docs.add(path);
        }
      }

      // Keep only one document if multiple were selected
      if (docs.length > 1) {
        docs = [docs.first];
      }

      return [...images, ...docs];
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String?> scanQRCode() {
    // TODO: implement scanQRCode
    throw UnimplementedError();
  }
}
