import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS('canWebShare')
external bool _jsCanWebShare();

@JS('shareCurrentPage')
external JSPromise<JSBoolean> _jsShareCurrentPage(
  JSString title,
  JSString text,
  JSString url,
);

/// 현재 페이지 공유 서비스.
///
/// 웹 환경에서는 navigator.share를 우선 사용한다.
class ShareService {
  ShareService._();

  static bool get canShare {
    if (!kIsWeb) return false;
    try {
      return _jsCanWebShare();
    } catch (_) {
      return false;
    }
  }

  static Future<bool> shareCurrentPage({
    required String title,
    required String text,
    String? url,
  }) async {
    if (!kIsWeb) return false;
    try {
      final ok = await _jsShareCurrentPage(
        title.toJS,
        text.toJS,
        (url ?? Uri.base.toString()).toJS,
      ).toDart;
      return ok.toDart;
    } catch (_) {
      return false;
    }
  }
}
