import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/account_dialog_strings.dart';
import '../models/religion.dart';
import '../models/country.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../config/routes.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';

/// 메인 화면 우측 상단 사람 아이콘 탭 시 표시 (테스트 유저, 종교/국가 선택, Google 로그인)
class AccountDialog extends ConsumerStatefulWidget {
  const AccountDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => const AccountDialog(),
    );
  }

  @override
  ConsumerState<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends ConsumerState<AccountDialog> {
  final _displayNameController = TextEditingController();
  String? _idError;
  bool _idSaving = false;
  bool _savingReligionCountry = false;
  bool _checkingDuplicate = false;
  CheckDisplayNameResult? _duplicateCheckResult;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicate(String name) async {
    if (name.trim().isEmpty) {
      setState(() {
        _duplicateCheckResult = CheckDisplayNameResult.empty;
        _idError = '아이디를 입력해 주세요.';
      });
      return;
    }
    setState(() {
      _checkingDuplicate = true;
      _idError = null;
      _duplicateCheckResult = null;
    });
    final result = await UserProfileRepository.checkDisplayNameAvailable(name);
    if (!mounted) return;
    setState(() {
      _checkingDuplicate = false;
      _duplicateCheckResult = result;
      if (result == CheckDisplayNameResult.duplicate) _idError = '이미 사용 중인 아이디입니다.';
      if (result == CheckDisplayNameResult.empty) _idError = '아이디를 입력해 주세요.';
    });
  }

  void _pickReligion(BuildContext context) {
    final rid = ref.read(testPointProvider).state.selectedReligionId;
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('나의 종교'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: defaultReligions.map((r) {
              return ListTile(
                title: Text(r.name),
                selected: rid == r.id,
                onTap: () => Navigator.pop(ctx, r.id),
              );
            }).toList(),
          ),
        ),
      ),
    ).then((id) {
      if (id != null) {
        ref.read(testPointProvider).setReligion(id);
        final uid = AuthService.currentUser?.uid;
        if (uid != null) UserProfileRepository.updateReligion(uid, id);
      }
    });
  }

  void _pickCountry(BuildContext context) {
    final cid = ref.read(testPointProvider).state.selectedCountryId;
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('나의 국가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: defaultCountries.map((c) {
              return ListTile(
                title: Text('${c.name} (${c.nameEn})'),
                selected: cid == c.id,
                onTap: () => Navigator.pop(ctx, c.id),
              );
            }).toList(),
          ),
        ),
      ),
    ).then((id) {
      if (id != null) {
        ref.read(testPointProvider).setCountry(id);
        final uid = AuthService.currentUser?.uid;
        if (uid != null) UserProfileRepository.updateCountry(uid, id);
      }
    });
  }

  Future<void> _saveDisplayName(String uid) async {
    final name = _displayNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _idError = '아이디를 입력해 주세요.');
      return;
    }
    setState(() {
      _idError = null;
      _idSaving = true;
    });
    final (result, failureMessage) = await UserProfileRepository.setDisplayName(uid, name);
    if (!mounted) return;
    setState(() => _idSaving = false);
    switch (result) {
      case SetDisplayNameResult.success:
        ref.invalidate(accountRankingFromServerProvider);
        setState(() => _idError = null);
        break;
      case SetDisplayNameResult.duplicate:
        setState(() => _idError = '이미 사용 중인 아이디입니다.');
        break;
      case SetDisplayNameResult.empty:
        setState(() => _idError = '아이디를 입력해 주세요.');
        break;
      case SetDisplayNameResult.failure:
        setState(() => _idError = failureMessage ?? '저장에 실패했습니다.');
        break;
    }
  }

  /// 종교·국가 확인 다이얼로그 표시. 사용자가 '확인'을 누르면 true 반환.
  Future<bool> _showReligionCountryConfirmDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AccountDialogStrings.confirmDialogTitle),
        content: const Text(AccountDialogStrings.confirmDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AccountDialogStrings.confirmDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AccountDialogStrings.confirmDialogConfirm),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _saveReligionAndCountry(String uid) async {
    final rid = ref.read(testPointProvider).state.selectedReligionId;
    final cid = ref.read(testPointProvider).state.selectedCountryId;
    if (rid == null || cid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('종교와 국가를 모두 선택한 뒤 저장해 주세요.')),
        );
      }
      return;
    }
    final confirmed = await _showReligionCountryConfirmDialog();
    if (!mounted || !confirmed) return;
    setState(() => _savingReligionCountry = true);
    try {
      await UserProfileRepository.updateReligion(uid, rid);
      await UserProfileRepository.updateCountry(uid, cid);
      await UserProfileRepository.lockProfile(uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AccountDialogStrings.saveCompleteMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: ${e.toString().length > 50 ? "네트워크를 확인해 주세요." : e}')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingReligionCountry = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testPointProvider).state;
    final user = AuthService.currentUser;

    if (user != null) {
      final profileAsync = ref.watch(currentUserProfileProvider);
      final profile = profileAsync.valueOrNull;
      if (profile?.displayName != null && _displayNameController.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _displayNameController.text.isEmpty) {
            _displayNameController.text = profile!.displayName!;
          }
        });
      }
      final rid = profile?.religionId ?? testState.selectedReligionId;
      final cid = profile?.countryId ?? testState.selectedCountryId;
      final religionName = rid != null
          ? defaultReligions.firstWhere((r) => r.id == rid, orElse: () => defaultReligions.first).name
          : null;
      final countryName = cid != null
          ? defaultCountries.firstWhere((c) => c.id == cid, orElse: () => defaultCountries.first).name
          : null;
      final locked = profile?.profileLocked ?? false;
      final maxH = MediaQuery.sizeOf(context).height * 0.55 - 20;

      final errorColor = Theme.of(context).colorScheme.error;
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AccountDialogStrings.titleAccount),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                user.email ?? '로그인됨',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH.clamp(200.0, 500.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text('광고 시청 ${profile.adWatchCount}회', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 16),
                      Icon(Icons.volunteer_activism, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text('기부 포인트 ${profile.points} P', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
                if (locked) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, size: 18, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AccountDialogStrings.lockedWarning,
                            style: TextStyle(fontSize: 12, color: errorColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Text('아이디 (랭킹에 표시)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _displayNameController,
                        readOnly: locked,
                        decoration: InputDecoration(
                          hintText: '원하는 아이디 입력',
                          isDense: true,
                          errorText: _idError,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onSubmitted: locked ? null : (_) => _saveDisplayName(user.uid),
                      ),
                    ),
                    if (!locked) ...[
                      const SizedBox(width: 6),
                      FilledButton.tonal(
                        onPressed: _checkingDuplicate ? null : () => _checkDuplicate(_displayNameController.text),
                        child: _checkingDuplicate
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('중복 검사'),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: _idSaving ? null : () => _saveDisplayName(user.uid),
                        child: _idSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('저장'),
                      ),
                    ],
                  ],
                ),
                if (!locked && _duplicateCheckResult == CheckDisplayNameResult.available)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('사용 가능한 아이디입니다.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                  ),
                if (_idError != null) const SizedBox(height: 4),
                const SizedBox(height: 16),
                const Text('나의 종교', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                _SelectField(
                  value: religionName,
                  hint: '선택하기',
                  onTap: locked ? null : () => _pickReligion(context),
                  enabled: !locked,
                ),
                const SizedBox(height: 8),
                const Text('나의 국가', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                _SelectField(
                  value: countryName,
                  hint: '선택하기',
                  onTap: locked ? null : () => _pickCountry(context),
                  enabled: !locked,
                ),
                if (!locked) ...[
                  const SizedBox(height: 10),
                  Text(
                    AccountDialogStrings.beforeSaveHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: errorColor, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _savingReligionCountry ? null : () => _saveReligionAndCountry(user.uid),
                      icon: _savingReligionCountry
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.check, size: 18),
                      label: Text(_savingReligionCountry ? '확인 중...' : AccountDialogStrings.confirmButtonLabel),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
          TextButton(
            onPressed: () async {
              await AuthService.signOut();
              // 앱 내부 상태 초기화 (이전 계정의 선택값/캐시 잔상 제거)
              ref.read(testPointProvider).reset();
              ref.invalidate(currentUserProfileProvider);
              // 랭킹 스트림도 새 로그인 시 깨끗하게 다시 구독
              ref.invalidate(accountRankingFromServerProvider);
              ref.invalidate(religionPointsFromServerProvider);
              ref.invalidate(countryPointsFromServerProvider);

              if (!context.mounted) return;
              Navigator.pop(context); // 다이얼로그 닫기
              // 화면 스택을 로그인으로 리셋
              context.go(AppRoutes.login);
            },
            child: const Text('로그아웃'),
          ),
        ],
      );
    }

    // 비로그인 시 계정 팝업 진입(정상 경로는 사람 버튼 → LoginOnlyDialog).
    // 진입 시 로그인만 보이므로 여기선 안내만 표시.
    return AlertDialog(
      title: const Text(AccountDialogStrings.loginRequiredTitle),
      content: const Text(AccountDialogStrings.loginRequiredMessage),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('닫기')),
      ],
    );
  }
}

/// 종교·국가 선택용 흰색 배경 필드 (TextField처럼 보이도록)
class _SelectField extends StatelessWidget {
  final String? value;
  final String hint;
  final VoidCallback? onTap;
  final bool enabled;

  const _SelectField({
    required this.value,
    required this.hint,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled && onTap != null ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey.shade100,
            border: Border.all(
              color: value != null
                  ? Theme.of(context).colorScheme.outline
                  : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 14,
                  color: value != null ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
