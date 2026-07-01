import 'package:app/app/routes.dart';
import 'package:app/features/splash/domain/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider.notifier).initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(splashViewModelProvider);

    if (!isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.home);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
              ),
              height: 55,
              width: 55,
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tablemind",
              style: TextStyle(
                fontFamily: "Antic",
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            AnimatedCrossFade(
              firstChild: Container(color: Colors.white60, width: 0, height: 0),
              secondChild: Container(
                color: Colors.white60,
                width: 150,
                height: 1,
              ),
              crossFadeState: CrossFadeState.showSecond,
              duration: Duration(milliseconds: 2000),
            ),
            Text(
              "MENU INTELLIGENCE",
              style: TextStyle(
                fontFamily: "Antic",
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
