import 'package:app/features/processing/data/processing_repository.dart';
import 'package:app/features/processing/domain/menu_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../shared/entities/menu_entity.dart';
import 'processing_usecase.dart';

final processingRepositoryProvider = Provider.autoDispose<ProcessingRepository>(
  (ref) {
    final repo = ProcessingRepositoryImpl();

    ref.onDispose(repo.dispose);
    return repo;
  },
);

final menuParserProvider = Provider.autoDispose<MenuParser>(
  (ref) => MenuParser(),
);

final processingUseCaseProvider = Provider.autoDispose<ProcessingUseCase>((
  ref,
) {
  final repo = ref.watch(processingRepositoryProvider);
  final parser = ref.watch(menuParserProvider);
  return ProcessingUseCase(repo, parser);
});

final processingViewModelProvider =
    StateNotifierProvider.autoDispose<ProcessingViewModel, ProcessingState>((
      ref,
    ) {
      final useCase = ref.watch(processingUseCaseProvider);
      return ProcessingViewModel(useCase);
    });

class ProcessingViewModel extends StateNotifier<ProcessingState> {
  final ProcessingUseCase _useCase;

  ProcessingViewModel(this._useCase) : super(const ProcessingState());

  Future<void> scanImages(List<String> imagePaths) async {
    state = ProcessingState(isLoading: true, totalImages: imagePaths.length);

    try {
      await for (final progress in _useCase.scanMenuFromImages(imagePaths)) {
        state = ProcessingState(
          isLoading: !progress.isDone,
          menu: progress.menu,
          completedImages: progress.completed,
          totalImages: progress.total,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = ProcessingState(
        isLoading: false,
        errorMessage: e.toString(),
        totalImages: imagePaths.length,
      );
    }
  }
}

class ProcessingState {
  final bool isLoading;
  final String? errorMessage;
  final Menu? menu;
  final int completedImages;
  final int totalImages;

  const ProcessingState({
    this.isLoading = false,
    this.errorMessage,
    this.menu,
    this.completedImages = 0,
    this.totalImages = 0,
  });
}
