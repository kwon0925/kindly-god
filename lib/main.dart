import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/firebase_config.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.web);
  runApp(const ProviderScope(child: KindlyApp()));
}

class KindlyApp extends StatelessWidget {
  const KindlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kindly',
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
