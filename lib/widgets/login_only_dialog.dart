import 'package:flutter/material.dart';
import '../constants/account_dialog_strings.dart';
import '../services/auth_service.dart';
import 'account_dialog.dart';

/// 비로그인 시 사람 버튼 탭 → 구글 로그인 버튼만 보이는 팝업.
/// 로그인 성공 시 이 팝업을 닫고 계정 팝업(AccountDialog)을 연다.
/// 신규 사용자면 입력 가능, 기존 사용자면 비활성화(잠금)된 계정 팝업이 뜬다.
class LoginOnlyDialog extends StatefulWidget {
  const LoginOnlyDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => const LoginOnlyDialog(),
    );
  }

  @override
  State<LoginOnlyDialog> createState() => _LoginOnlyDialogState();
}

class _LoginOnlyDialogState extends State<LoginOnlyDialog> {
  bool _loading = false;
  String? _error;

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
      if (context.mounted) AccountDialog.show(context);
    } else {
      setState(() => _error = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AccountDialogStrings.loginOnlyTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
            const SizedBox(height: 12),
          ],
          FilledButton.icon(
            onPressed: _loading ? null : _signInWithGoogle,
            icon: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.g_mobiledata, size: 22),
            label: Text(_loading ? AccountDialogStrings.googleLoginLoading : AccountDialogStrings.googleLoginButton),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
