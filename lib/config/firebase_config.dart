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
