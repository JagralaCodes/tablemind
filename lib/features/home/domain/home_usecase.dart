import 'package:app/features/home/data/home_repository.dart';

class HomeUseCase {
  final HomeRepository repository;

  HomeUseCase(this.repository);

  Future<List<String?>> uploadFromCamera() {
    return repository.pickImagesFromCamera();
  }

  Future<List<String?>> uploadFileFromStorage() {
    return repository.pickFileFromStorage();
  }

  Future<String?> scanQRCode() {
    return repository.scanQRCode();
  }
}
