import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/firebase_config.dart';
import 'config/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.web);

  // Flutter 웹 release 빌드에서 Firestore 채널 연결 실패 방지.
  // persistenceEnabled: false → 오프라인 캐시 비활성화(웹 기본값)로 WebSocket 대신 HTTP 사용.
  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      sslEnabled: true,
    );
  }

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
