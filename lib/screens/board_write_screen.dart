import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../repository/board_repository.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';

/// 게시글 작성 화면
/// - 로그인 사용자만 접근 가능
/// - 아이디명 or 익명 선택
class BoardWriteScreen extends ConsumerStatefulWidget {
  const BoardWriteScreen({super.key});

  @override
  ConsumerState<BoardWriteScreen> createState() => _BoardWriteScreenState();
}

class _BoardWriteScreenState extends ConsumerState<BoardWriteScreen> {
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
      // 저장된 아이디명 조회 (없으면 이메일 앞부분 사용)
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 작성'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    '등록',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('로그인이 필요합니다.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 표시 영역
                  _AuthorChip(isAnonymous: _isAnonymous),
                  const SizedBox(height: 4),
                  // 익명 토글
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
                  // 제목
                  TextField(
                    controller: _titleController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      labelText: '제목',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 본문
                  TextField(
                    controller: _bodyController,
                    maxLines: 12,
                    maxLength: 3000,
                    decoration: const InputDecoration(
                      labelText: '내용',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// 현재 로그인 사용자 이름 표시 칩
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
        final label = isAnonymous ? '익명으로 게시됩니다' : '$displayName 으로 게시됩니다';
        return Chip(
          avatar: Icon(
            isAnonymous ? Icons.visibility_off : Icons.person,
            size: 16,
          ),
          label: Text(label, style: const TextStyle(fontSize: 13)),
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}
