import 'package:app/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TablemindApp extends ConsumerWidget {
  const TablemindApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Tablemind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
        useMaterial3: true,
        fontFamily: 'Comfortaa',
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[700]),
          headlineMedium: TextStyle(color: Colors.black),
        ),
      ),
      routerConfig: router,
    );
  }
}
