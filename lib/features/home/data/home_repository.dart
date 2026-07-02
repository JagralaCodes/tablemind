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
      return result != null ? result.files.map((e) => e.path).toList() : [];
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
