import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/flag_assets_service.dart';

/// code(소문자 2글자) → assetPath
final flagAssetsByCodeProvider = FutureProvider<Map<String, String>>((ref) async {
  return FlagAssetsService.loadFlagAssetsByCode();
});

