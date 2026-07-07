import 'package:flutter_riverpod/legacy.dart';
import 'package:app/features/home/domain/home_usecase.dart';
import 'package:app/features/home/domain/home_view_model.dart';

final uploadViewModelProvider = StateNotifierProvider.autoDispose
    .family<UploadViewModel, List<String>, List<String>>((ref, initialPaths) {
      final useCase = ref.watch(homeUseCaseProvider);
      return UploadViewModel(initialPaths, useCase);
    });

class UploadViewModel extends StateNotifier<List<String>> {
  final HomeUseCase _useCase;

  UploadViewModel(super.initialPaths, this._useCase);

  void removePath(int index) {
    if (index >= 0 && index < state.length) {
      final newState = List<String>.from(state);
      newState.removeAt(index);
      state = newState;
    }
  }

  Future<void> addMoreFromCamera() async {
    final filePaths = await _useCase.uploadFromCamera();
    final validPaths = filePaths.whereType<String>().toList();
    if (validPaths.isNotEmpty) {
      state = [...state, ...validPaths];
    }
  }

  Future<void> addMoreFromGallery() async {
    final filePaths = await _useCase.uploadFileFromStorage();
    final validPaths = filePaths.whereType<String>().toList();
    if (validPaths.isNotEmpty) {
      state = [...state, ...validPaths];
    }
  }
}
