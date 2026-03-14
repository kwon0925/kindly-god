import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_point_state.dart';

final testPointProvider = ChangeNotifierProvider<TestPointNotifier>((ref) => TestPointNotifier());
