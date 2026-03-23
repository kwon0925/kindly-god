import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/admin/admin_role.dart';
import '../constants/account_dialog_strings.dart';
import '../models/religion.dart';
import '../models/country.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../state/locale_provider.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';
import 'language_picker_sheet.dart';

/// ?? ?? ?? ?? ?? ??? ? ? ??
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
  bool _adminSigningIn = false;
  String? _adminError;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicate(String name) async {
    final l10n = AppLocalizations.of(context);
    if (name.trim().isEmpty) {
      setState(() {
        _duplicateCheckResult = CheckDisplayNameResult.empty;
        _idError = l10n.idEmpty;
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
      if (result == CheckDisplayNameResult.duplicate) _idError = l10n.idDuplicate;
      if (result == CheckDisplayNameResult.empty) _idError = l10n.idEmpty;
    });
  }

  void _pickReligion(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rid = ref.read(testPointProvider).state.selectedReligionId;
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.myReligion),
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
    final l10n = AppLocalizations.of(context);
    final cid = ref.read(testPointProvider).state.selectedCountryId;
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.myCountry),
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
    final l10n = AppLocalizations.of(context);
    final name = _displayNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _idError = l10n.idEmpty);
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
        setState(() => _idError = l10n.idDuplicate);
        break;
      case SetDisplayNameResult.empty:
        setState(() => _idError = l10n.idEmpty);
        break;
      case SetDisplayNameResult.failure:
        setState(() => _idError = failureMessage ?? l10n.error);
        break;
    }
  }

  /// ??·?? ?? ?????. ???? '??'? ??? true ??.
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
          const SnackBar(content: Text('??? ??? ?? ??? ? ??? ???.')),
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
          SnackBar(content: Text('?? ??: ${e.toString().length > 50 ? "????? ??? ???." : e}')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingReligionCountry = false);
    }
  }

  Future<void> _signInAsAdmin() async {
    setState(() {
      _adminSigningIn = true;
      _adminError = null;
    });
    try {
      final result = await AuthService.signInAsAdmin();
      if (!mounted) return;
      setState(() => _adminSigningIn = false);
      if (!result.success) {
        setState(() => _adminError = result.message ?? '??? ??? ??');
        return;
      }
      ref.invalidate(authUserProvider);
      ref.invalidate(currentUserProfileProvider);
      ref.invalidate(accountRankingFromServerProvider);
      ref.invalidate(religionPointsFromServerProvider);
      ref.invalidate(countryPointsFromServerProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).adminAccessSuccess)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _adminSigningIn = false;
        _adminError = '??? ??? ??';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testPointProvider).state;
    final user = AuthService.currentUser;
    final l10n = AppLocalizations.of(context);

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
      final isAdmin = AdminRole.isAdmin(profile?.role);
      final religionName = rid != null
          ? defaultReligions.firstWhere((r) => r.id == rid, orElse: () => defaultReligions.first).name
          : null;
      final countryName = cid != null
          ? defaultCountries.firstWhere((c) => c.id == cid, orElse: () => defaultCountries.first).name
          : null;
      final locked = profile?.profileLocked ?? false;
      final maxH = MediaQuery.sizeOf(context).height * 0.6 - 20;

      final errorColor = Theme.of(context).colorScheme.error;
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.account),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${user.email ?? '????'}${isAdmin ? ' (ADMIN)' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH.clamp(200.0, 560.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ??? ??
                if (profile != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(l10n.adWatchCount(profile.adWatchCount), style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 16),
                      Icon(Icons.volunteer_activism, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(l10n.donationPoints(profile.points), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],

                // ?? ??
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
                            l10n.lockedWarning,
                            style: TextStyle(fontSize: 12, color: errorColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ?? ?? ?? (profileLocked? ???? ?? ???) ??
                const SizedBox(height: 16),
                Text(l10n.languageSettings, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                const LanguagePickerTile(),

                // ??? ??
                if (_adminError != null) ...[
                  const SizedBox(height: 8),
                  Text(_adminError!, style: TextStyle(fontSize: 12, color: errorColor)),
                ],

                // ???
                const SizedBox(height: 16),
                Text(l10n.myId, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _displayNameController,
                        readOnly: locked,
                        decoration: InputDecoration(
                          hintText: l10n.myIdHint,
                          isDense: true,
                          errorText: _idError,
                          filled: true,
                          fillColor: locked ? Colors.grey.shade100 : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: locked ? Colors.grey.shade400 : Theme.of(context).colorScheme.outline,
                            ),
                          ),
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
                            : Text(l10n.duplicateCheck),
                      ),
                      const SizedBox(width: 6),
                      FilledButton(
                        onPressed: _idSaving ? null : () => _saveDisplayName(user.uid),
                        child: _idSaving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(l10n.save),
                      ),
                    ],
                  ],
                ),
                if (!locked && _duplicateCheckResult == CheckDisplayNameResult.available)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(l10n.idAvailable, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                  ),

                // ?? / ??
                const SizedBox(height: 16),
                Text(l10n.myReligion, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                _SelectField(
                  value: religionName,
                  hint: l10n.select,
                  onTap: locked ? null : () => _pickReligion(context),
                  enabled: !locked,
                ),
                const SizedBox(height: 8),
                Text(l10n.myCountry, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 4),
                _SelectField(
                  value: countryName,
                  hint: l10n.select,
                  onTap: locked ? null : () => _pickCountry(context),
                  enabled: !locked,
                ),
                if (!locked) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.beforeSaveHint,
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
                      label: Text(_savingReligionCountry ? l10n.saving : AccountDialogStrings.confirmButtonLabel),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _adminSigningIn ? null : _signInAsAdmin,
            icon: _adminSigningIn
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.admin_panel_settings_outlined, size: 16),
            label: Text(_adminSigningIn ? l10n.adminAccessLoading : l10n.adminAccess),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
          TextButton(
            onPressed: () async {
              await AuthService.signOut();
              ref.invalidate(authUserProvider);
              ref.invalidate(currentUserProfileProvider);
              ref.invalidate(accountRankingFromServerProvider);
              ref.invalidate(religionPointsFromServerProvider);
              ref.invalidate(countryPointsFromServerProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.logout),
          ),
        ],
      );
    }

    // ????: ??? ?? + ?? ??
    return AlertDialog(
      title: Text(l10n.loginRequired),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.loginRequiredMessage),
          const SizedBox(height: 20),
          Text(l10n.languageSettings, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          const LanguagePickerTile(),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
      ],
    );
  }
}

/// ??·?? ??? ?? ?? ??
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
