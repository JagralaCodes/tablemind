import 'package:flutter_riverpod/legacy.dart';

class SplashViewModel extends StateNotifier<bool> {
  SplashViewModel() : super(true);

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    state = false;
  }
}

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, bool>((
  ref,
) {
  return SplashViewModel();
});
