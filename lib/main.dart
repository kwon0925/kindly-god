import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_brand.dart';
import 'config/app_theme.dart';
import 'config/firebase_config.dart';
import 'config/routes.dart';
import 'services/fcm_service.dart';
import 'state/fcm_provider.dart';
import 'state/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.web);

  // Flutter Web release 빌드에서 Firestore 캐시 비활성화
  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      sslEnabled: true,
    );
  }

  // FCM 초기화 (백그라운드 핸들러, 포그라운드 리스너, 토큰 갱신 리스너 등록)
  await FcmService.init();

  runApp(const ProviderScope(child: KindlyGodApp()));
}

class KindlyGodApp extends ConsumerWidget {
  const KindlyGodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    // FCM: ?? ?? ?? ?? + Auth ?? ? ?? ?? ??
    ref.watch(notificationPermissionLoaderProvider);
    ref.watch(fcmAuthSyncProvider);

    return MaterialApp.router(
      title: kAppDisplayName,
      theme: appTheme,
      routerConfig: appRouter,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
