import 'package:app/app/router.dart';
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

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, void>((ref) {
  final useCase = ref.watch(homeUseCaseProvider);
  final route = ref.watch(routerProvider);
  return HomeViewModel(useCase, route);
});

class HomeViewModel extends StateNotifier<void> {
  final HomeUseCase _useCase;
  final GoRouter _route;

  HomeViewModel(this._useCase, this._route) : super(null);

  // Camera Button
  Future<void> onCameraTap() async {
    final filePaths = await _useCase.uploadFromCamera();
    final validPaths = filePaths.whereType<String>().toList();
    if (validPaths.isNotEmpty) {
      _route.push(
        AppRoutes.upload,
        extra: {'paths': validPaths, 'source': 'camera'},
      );
    }
  }

  // upload file Picker
  Future<void> onFilePickerTap() async {
    final filePaths = await _useCase.uploadFileFromStorage();
    final validPaths = filePaths.whereType<String>().toList();
    if (validPaths.isNotEmpty) {
      _route.push(
        AppRoutes.upload,
        extra: {'paths': validPaths, 'source': 'gallery'},
      );
    }
  }
}
