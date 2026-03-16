import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/religion.dart';
import '../models/country.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
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
  bool _loading = false;
  String? _error;
  final _nameControllers = <String, TextEditingController>{};
  final _displayNameController = TextEditingController();
  String? _idError;
  bool _idSaving = false;
  bool _savingReligionCountry = false;
  bool _checkingDuplicate = false;
  CheckDisplayNameResult? _duplicateCheckResult;

  @override
  void dispose() {
    _displayNameController.dispose();
    for (final c in _nameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _nameController(String id) {
    return _nameControllers.putIfAbsent(id, () => TextEditingController());
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await AuthService.signInWithGoogle();
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      Navigator.of(context).pop();
    } else {
      setState(() => _error = result.message);
    }
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
    setState(() => _savingReligionCountry = true);
    try {
      await UserProfileRepository.updateReligion(uid, rid);
      await UserProfileRepository.updateCountry(uid, cid);
      await UserProfileRepository.lockProfile(uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('설정이 완료되었습니다. 아이디·종교·국가는 변경할 수 없습니다.')),
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

      return AlertDialog(
        title: const Text('계정'),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH.clamp(200.0, 500.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email ?? '로그인됨', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700)),
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
                            '한 번 설정된 아이디·종교·국가는 변경할 수 없습니다.',
                            style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
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
                  Text('종교·국가 선택 후 저장하면 이후 변경할 수 없습니다.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _savingReligionCountry ? null : () => _saveReligionAndCountry(user.uid),
                      icon: _savingReligionCountry
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save, size: 18),
                      label: Text(_savingReligionCountry ? '저장 중...' : '종교·국가 저장'),
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
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('로그아웃'),
          ),
        ],
      );
    }

    final religionName = testState.selectedReligionId != null
        ? defaultReligions.firstWhere((r) => r.id == testState.selectedReligionId, orElse: () => defaultReligions.first).name
        : null;
    final countryName = testState.selectedCountryId != null
        ? defaultCountries.firstWhere((c) => c.id == testState.selectedCountryId, orElse: () => defaultCountries.first).name
        : null;

    final maxH = MediaQuery.sizeOf(context).height * 0.55 - 20;

    return AlertDialog(
      title: const Text('계정 / 로그인'),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH.clamp(200.0, 500.0)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('테스트: 계정 선택 (A, B, C)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['A', 'B', 'C'].map((id) {
                  final selected = testState.currentTestUser == id;
                  final displayName = testState.getAccountDisplayName(id);
                  return FilterChip(
                    label: Text(displayName, overflow: TextOverflow.ellipsis),
                    selected: selected,
                    onSelected: (_) => ref.read(testPointProvider).setTestUser(id),
                  );
                }).toList(),
              ),
              if (testState.currentTestUser != null) ...[
                const SizedBox(height: 10),
                Text('계정 이름 (계정별 랭킹에 표시)', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final uid = testState.currentTestUser!;
                    final c = _nameController(uid);
                    final saved = (testState.userDisplayNames[uid] ?? '').trim();
                    if (c.text.isEmpty && saved.isNotEmpty) c.text = saved;
                    return TextField(
                      controller: c,
                      decoration: InputDecoration(
                        hintText: '유저 $uid',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (v) => ref.read(testPointProvider).setUserDisplayName(uid, v),
                    );
                  },
                ),
              ],
              const SizedBox(height: 12),
              const Text('나의 종교', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              _SelectField(value: religionName, hint: '선택하기', onTap: () => _pickReligion(context)),
              const SizedBox(height: 8),
              const Text('나의 국가', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              _SelectField(value: countryName, hint: '선택하기', onTap: () => _pickCountry(context)),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 6),
            const Text('Google 로그인', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
              const SizedBox(height: 4),
            ],
            ElevatedButton.icon(
              onPressed: _loading ? null : _signInWithGoogle,
              icon: _loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.g_mobiledata, size: 20),
              label: Text(_loading ? '로그인 중...' : 'Google로 로그인', style: const TextStyle(fontSize: 13)),
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
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
