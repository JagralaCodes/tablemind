import 'package:app/app/routes.dart';
import 'package:app/features/home/data/home_repository.dart';
import 'package:app/features/home/domain/home_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final homeUseCaseProvider = Provider<HomeUseCase>((ref) {
  final repo = ref.watch(homeRepositoryProvider);
  return HomeUseCase(repo);
});

class HomeViewModel extends StateNotifier<void> {
  final HomeUseCase _useCase;
  final GoRouter _route;

  HomeViewModel(this._useCase, this._route) : super(null);

  // Camera Button
  Future<void> onCameraTap() async {
    final filePath = await _useCase.uploadFromCamera();
    if (filePath.isNotEmpty) {
      _route.push(
        AppRoutes.preview,
        extra: {'path': filePath, 'source': 'camera'},
      );
    } else {}
  }

  // upload file Picker
  Future<void> onFilePickerTap() async {
    final filePath = await _useCase.uploadFileFromStorage();
    if (filePath.isNotEmpty) {
      _route.push(
        AppRoutes.preview,
        extra: {'path': filePath, 'source': 'gallery'},
      );
    } else {}
  }

  // scanner
  Future<void> onScannerTap() async {
    _route.push(AppRoutes.scanner);
  }

  // restaurant search
  Future<void> onSearchRestaurantTap() async {
    _route.push(AppRoutes.search);
  }
}
