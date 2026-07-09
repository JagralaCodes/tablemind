import 'package:app/features/processing/presantation/processing_page.dart';

import '../app/routes.dart';
import '../features/preview/presantation/preview_detail_page.dart';
import '../features/home/presantation/home_screen.dart';
import '../features/scanner/presantation/qr_scanner_page.dart';
import '../features/splash/presantaion/splash_screen.dart';
import '../features/search/presentation/search_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/upload/domain/upload_args.dart';
import '../features/upload/presantation/upload_page.dart';
import '../shared/entities/menu_entity.dart';

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
          final args = state.extra as UploadArgs;
          return UploadPage(initialPaths: args.paths);
        },
      ),
      GoRoute(
        path: AppRoutes.processing,
        builder: (context, state) {
          // ProcessingScreen expects List<String> directly (that's what
          // upload_page.dart's Process Menu button sends via
          // `context.push(AppRoutes.processing, extra: imagePaths)`)
          final imagePaths = state.extra as List<String>;
          return ProcessingScreen(imagePaths: imagePaths);
        },
      ),
      GoRoute(
        path: AppRoutes.preview,
        builder: (context, state) {
          final menu = state.extra as Menu;
          return PreviewScreen(menu: menu);
        },
      ),
    ],
  );
});
