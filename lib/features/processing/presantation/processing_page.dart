import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/app/routes.dart';
import '../domain/processing_view_model.dart';

/// Receives ALL image paths selected on the Upload page and OCR-scans
/// them one by one, showing live progress.
class ProcessingScreen extends ConsumerStatefulWidget {
  final List<String> imagePaths;

  const ProcessingScreen({super.key, required this.imagePaths});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(processingViewModelProvider.notifier)
          .scanImages(widget.imagePaths),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(processingViewModelProvider);

    // Note the `!next.isLoading` check here: `next.menu` is populated on
    // EVERY progress tick (not just the last one) so the state can show a
    // running total, but we only want to actually NAVIGATE once the whole
    // scan is finished — otherwise we'd push the Preview route after just
    // the first image.
    ref.listen<ProcessingState>(processingViewModelProvider, (previous, next) {
      if (!next.isLoading && next.menu != null && next.errorMessage == null) {
        context.push(AppRoutes.preview, extra: next.menu);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: state.errorMessage != null
            ? _ScanError(
                message: state.errorMessage!,
                onRetry: () => ref
                    .read(processingViewModelProvider.notifier)
                    .scanImages(widget.imagePaths),
              )
            : _ScanningIndicator(
                completed: state.completedImages,
                total: state.totalImages,
              ),
      ),
    );
  }
}

class _ScanningIndicator extends StatelessWidget {
  final int completed;
  final int total;

  const _ScanningIndicator({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: Colors.black),
        const SizedBox(height: 24),
        Text(
          total > 0
              ? "Reading menu... ($completed of $total)"
              : "Reading your menu...",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ScanError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ScanError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.black54),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onRetry, child: const Text("Try again")),
        ],
      ),
    );
  }
}
