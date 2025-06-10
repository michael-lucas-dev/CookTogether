import 'dart:ui';

import 'package:cooktogether/router/app_router.dart';
import 'package:cooktogether/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cooktogether/firebase_options.dart';
import 'package:cooktogether/core/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppLogger.info('Début de l\'application');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    final crashlytics = FirebaseCrashlytics.instance;
    crashlytics.setCrashlyticsCollectionEnabled(true);

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    final performance = FirebasePerformance.instance;
    await performance.setPerformanceCollectionEnabled(true);

    runApp(const ProviderScope(child: MainApp()));
    AppLogger.info('Application démarrée avec succès');
  } catch (e, stackTrace) {
    AppLogger.error('Erreur lors du démarrage de l\'application', e, stackTrace);
    debugPrint('Firebase initialization error: $e');
    runApp(const ProviderScope(child: MainApp()));
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger.info('Construction de l\'interface utilisateur');
    return MaterialApp.router(
      title: 'Cook Together',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
