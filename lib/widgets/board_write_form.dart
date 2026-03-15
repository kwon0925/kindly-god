import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../repository/board_repository.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import 'board_button_style.dart';

/// 게시글 작성 폼 위젯 — 로직과 UI를 담당
/// board_write_screen.dart 에서 사용
class BoardWriteForm extends ConsumerStatefulWidget {
  const BoardWriteForm({super.key});

  @override
  ConsumerState<BoardWriteForm> createState() => _BoardWriteFormState();
}

class _BoardWriteFormState extends ConsumerState<BoardWriteForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isAnonymous = false;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = AuthService.currentUser;
    if (user == null) {
      _showSnack('게시글을 작성하려면 로그인이 필요합니다.');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showSnack('제목을 입력해 주세요.');
      return;
    }
    if (_bodyController.text.trim().isEmpty) {
      _showSnack('내용을 입력해 주세요.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final profile = await UserProfileRepository.getProfile(user.uid);
      final displayName = (profile?.displayName?.isNotEmpty == true)
          ? profile!.displayName!
          : (user.email?.split('@').first ?? '사용자');

      await BoardRepository.createPost(
        title: _titleController.text,
        body: _bodyController.text,
        authorUid: user.uid,
        authorDisplayName: displayName,
        isAnonymous: _isAnonymous,
      );

      if (mounted) {
        _showSnack('게시글이 등록되었습니다.');
        context.pop();
      }
    } catch (e) {
      if (mounted) _showSnack('등록 실패: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return const Center(
        child: Text('로그인 후 게시글을 작성할 수 있습니다.'),
      );
    }

    return Column(
      children: [
        // ── 폼 입력 영역 (스크롤 가능) ──────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 작성자 칩
                _AuthorChip(isAnonymous: _isAnonymous),
                // 익명 체크박스
                Row(
                  children: [
                    Checkbox(
                      value: _isAnonymous,
                      onChanged: (v) =>
                          setState(() => _isAnonymous = v ?? false),
                    ),
                    const Text('익명으로 게시'),
                  ],
                ),
                const SizedBox(height: 16),
                // 제목 입력
                TextField(
                  controller: _titleController,
                  maxLength: 100,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: '제목 *',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),
                // 본문 입력
                TextField(
                  controller: _bodyController,
                  maxLines: 14,
                  maxLength: 3000,
                  decoration: const InputDecoration(
                    labelText: '내용 *',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── 게시하기 버튼 (하단 고정) ────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: BoardButtonStyle.submit,
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _submitting ? '게시 중...' : '게시하기',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 작성자 표시 칩 (아이디명 or 익명)
class _AuthorChip extends ConsumerWidget {
  final bool isAnonymous;

  const _AuthorChip({required this.isAnonymous});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AuthService.currentUser;
    if (user == null) return const SizedBox.shrink();

    return FutureBuilder(
      future: UserProfileRepository.getProfile(user.uid),
      builder: (context, snap) {
        final displayName = snap.data?.displayName?.isNotEmpty == true
            ? snap.data!.displayName!
            : (user.email?.split('@').first ?? '사용자');
        final label =
            isAnonymous ? '익명으로 게시됩니다' : '$displayName 으로 게시됩니다';
        return Chip(
          avatar: Icon(
            isAnonymous ? Icons.visibility_off : Icons.person_outline,
            size: 16,
          ),
          label: Text(label, style: const TextStyle(fontSize: 13)),
          padding: EdgeInsets.zero,
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
        );
      },
    );
  }
}
