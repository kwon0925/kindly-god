import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase 웹 앱 설정 (kindly-god 프로젝트)
class FirebaseConfig {
  FirebaseConfig._();

  static const String projectId = 'kindly-god';
  static const String appId = '1:377587650257:web:70626937031928290ffff0';
  static const String messagingSenderId = '377587650257';
  static const String apiKey = 'AIzaSyDm9UfHNLibksg2sYYm1o1NE89cwtYPQZs';
  static const String authDomain = 'kindly-god.firebaseapp.com';
  static const String storageBucket = 'kindly-god.firebasestorage.app';
  static const String measurementId = 'G-2DVYK08PQE';

  /// Google 로그인(웹)용 OAuth 클라이언트 ID.
  static const String? googleWebClientId = '377587650257-8gtoercocj3r6v1hb2ggc6osqoek7cjm.apps.googleusercontent.com';

  /// 웹 푸시(FCM) VAPID 키.
  /// Firebase 콘솔 → 프로젝트 설정 → 클라우드 메시징 → 웹 푸시 인증서에서 생성 후 붙여넣기.
  static const String vapidKey =
      'BF-5NZ1TY0cqVVuv7lXfOpHl18pQ546Jz119t1DiCSZqv-MWD7wqP0fwE2M9xVpEcAqo5CfGDql36m_p2KeG4Ek';

  static FirebaseOptions get web => const FirebaseOptions(
        apiKey: apiKey,
        authDomain: authDomain,
        projectId: projectId,
        storageBucket: storageBucket,
        messagingSenderId: messagingSenderId,
        appId: appId,
        measurementId: measurementId,
      );
}
