import 'package:flutter/foundation.dart';
import '../models/religion.dart';
import '../models/country.dart';

/// 테스트용 포인트 상태. 앱 재시작 시 0부터 시작 (메모리만 사용)
class TestPointState {
  final String? currentTestUser; // 'A', 'B', 'C'
  final String? selectedReligionId;
  final String? selectedCountryId;
  final Map<String, int> religionPoints;
  final Map<String, int> userPoints;   // key: 'A', 'B', 'C'
  final Map<String, int> countryPoints;
  /// 계정별 표시 이름 (key: A,B,C / value: 사용자가 정한 이름)
  final Map<String, String> userDisplayNames;

  const TestPointState({
    this.currentTestUser,
    this.selectedReligionId,
    this.selectedCountryId,
    this.religionPoints = const {},
    this.userPoints = const {},
    this.countryPoints = const {},
    this.userDisplayNames = const {},
  });

  String getAccountDisplayName(String id) {
    final name = userDisplayNames[id]?.trim();
    return (name != null && name.isNotEmpty) ? name : '유저 $id';
  }

  int getReligionPoints(String id) => religionPoints[id] ?? 0;
  int getUserPoints(String id) => userPoints[id] ?? 0;
  int getCountryPoints(String id) => countryPoints[id] ?? 0;

  TestPointState copyWith({
    String? currentTestUser,
    String? selectedReligionId,
    String? selectedCountryId,
    Map<String, int>? religionPoints,
    Map<String, int>? userPoints,
    Map<String, int>? countryPoints,
    Map<String, String>? userDisplayNames,
  }) {
    return TestPointState(
      currentTestUser: currentTestUser ?? this.currentTestUser,
      selectedReligionId: selectedReligionId ?? this.selectedReligionId,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      religionPoints: religionPoints ?? this.religionPoints,
      userPoints: userPoints ?? this.userPoints,
      countryPoints: countryPoints ?? this.countryPoints,
      userDisplayNames: userDisplayNames ?? this.userDisplayNames,
    );
  }
}

class TestPointNotifier extends ChangeNotifier {
  TestPointState _state = const TestPointState();

  TestPointState get state => _state;

  static const testUserIds = ['A', 'B', 'C'];

  /// 로그아웃/초기화 시 호출: 선택값/테스트 포인트를 모두 초기화
  void reset() {
    _state = const TestPointState();
    notifyListeners();
  }

  void setTestUser(String? userId) {
    _state = _state.copyWith(currentTestUser: userId);
    notifyListeners();
  }

  void setOnboardingChoice(String religionId, String countryId) {
    _state = _state.copyWith(
      selectedReligionId: religionId,
      selectedCountryId: countryId,
    );
    notifyListeners();
  }

  void setReligion(String religionId) {
    _state = _state.copyWith(selectedReligionId: religionId);
    notifyListeners();
  }

  void setCountry(String countryId) {
    _state = _state.copyWith(selectedCountryId: countryId);
    notifyListeners();
  }

  void setUserDisplayName(String userId, String name) {
    final m = Map<String, String>.from(_state.userDisplayNames);
    m[userId] = name;
    _state = _state.copyWith(userDisplayNames: m);
    notifyListeners();
  }

  /// 금액만큼 포인트 적립 (종교·계정·국가에 반영). 성공 시 true
  bool addPoints(int amount) {
    if (amount <= 0) return false;
    final user = _state.currentTestUser;
    final religionId = _state.selectedReligionId;
    final countryId = _state.selectedCountryId;
    if (user == null || religionId == null || countryId == null) return false;

    final r = Map<String, int>.from(_state.religionPoints);
    final u = Map<String, int>.from(_state.userPoints);
    final c = Map<String, int>.from(_state.countryPoints);

    r[religionId] = (_state.getReligionPoints(religionId) + amount);
    u[user] = (_state.getUserPoints(user) + amount);
    c[countryId] = (_state.getCountryPoints(countryId) + amount);

    _state = _state.copyWith(religionPoints: r, userPoints: u, countryPoints: c);
    notifyListeners();
    return true;
  }

  /// 종교별 랭킹 (포인트 내림차순, 상위 5)
  List<({String id, String name, int points, int rank})> getReligionRanking() {
    final list = defaultReligions
        .map((r) => (id: r.id, name: r.name, points: _state.getReligionPoints(r.id)))
        .where((e) => e.points > 0)
        .toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list.asMap().entries.map((e) => (id: e.value.id, name: e.value.name, points: e.value.points, rank: e.key + 1)).take(5).toList();
  }

  /// 계정별 랭킹 (이름 반영)
  List<({String id, String name, int points, int rank})> getAccountRanking() {
    final list = testUserIds.map((id) => (id: id, name: _state.getAccountDisplayName(id), points: _state.getUserPoints(id))).where((e) => e.points > 0).toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list.asMap().entries.map((e) => (id: e.value.id, name: e.value.name, points: e.value.points, rank: e.key + 1)).take(5).toList();
  }

  /// 국가별 랭킹
  List<({String id, String name, int points, int rank})> getCountryRanking() {
    final list = defaultCountries
        .map((c) => (id: c.id, name: c.name, points: _state.getCountryPoints(c.id)))
        .where((e) => e.points > 0)
        .toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list.asMap().entries.map((e) => (id: e.value.id, name: e.value.name, points: e.value.points, rank: e.key + 1)).take(5).toList();
  }
}
