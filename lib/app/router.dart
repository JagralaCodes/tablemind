import '../app/routes.dart';
import '../features/preview/presantation/preview_detail_page.dart';
import '../features/home/presantation/home_screen.dart';
import '../features/scanner/presantation/qr_scanner_page.dart';
import '../features/splash/presantaion/splash_screen.dart';
import '../features/search/presentation/search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/upload/presantation/upload_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) {
          return const SearchPage();
        },
      ),

      // QR Scanner
      GoRoute(
        path: AppRoutes.scanner,
        builder: (context, state) {
          return const QRScannerPage();
        },
      ),
      // upload page
      GoRoute(
        path: AppRoutes.upload,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final paths = (extra?['paths'] as List<dynamic>?)?.cast<String>() ?? [];
          return UploadPage(initialPaths: paths);
        },
      ),
      GoRoute(
        path: AppRoutes.preview,
        builder: (context, state) {
          return const PreviewDetailPage();
        },
      ),
    ],
  );
});
