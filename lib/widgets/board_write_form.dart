import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/admin/admin_role.dart';
import '../repository/board_repository.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../models/community_post.dart';
import 'board_button_style.dart';

/// 게시글 작성 폼 — 상단에서 카테고리(활동소식/게시판) 선택 가능
class BoardWriteForm extends ConsumerStatefulWidget {
  const BoardWriteForm({
    super.key,
    this.initialReligion,
    this.initialCategory,
  });

  final String? initialReligion;
  final String? initialCategory;

  @override
  ConsumerState<BoardWriteForm> createState() => _BoardWriteFormState();
}

class _BoardWriteFormState extends ConsumerState<BoardWriteForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isAnonymous = false;
  bool _submitting = false;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory == PostCategory.news
        ? PostCategory.news
        : PostCategory.board;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _isBoard => _selectedCategory == PostCategory.board;

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
      final isAdmin = AdminRole.isAdmin(profile?.role) || user.isAnonymous;
      final userReligion = profile?.religionId;
      if (!isAdmin && (userReligion == null || userReligion.isEmpty)) {
        _showSnack('종교를 먼저 선택해야 글을 작성할 수 있습니다.');
        return;
      }
      if (!isAdmin &&
          widget.initialReligion != null &&
          widget.initialReligion!.isNotEmpty &&
          widget.initialReligion != userReligion) {
        _showSnack('선택한 종교 게시판에서만 글을 작성할 수 있습니다.');
        return;
      }

      final displayName = (profile?.displayName?.isNotEmpty == true)
          ? profile!.displayName!
          : (user.email?.split('@').first ?? '사용자');

      await BoardRepository.createPost(
        title: _titleController.text,
        body: _bodyController.text,
        authorUid: user.uid,
        authorDisplayName: displayName,
        isAnonymous: _isBoard ? _isAnonymous : false,
        religion: isAdmin
            ? (widget.initialReligion != null && widget.initialReligion!.isNotEmpty ? widget.initialReligion! : 'all')
            : userReligion!,
        category: _selectedCategory,
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    if (user == null) {
      return const Center(
        child: Text('로그인 후 게시글을 작성할 수 있습니다.'),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── 카테고리 선택 탭 (제목 위) ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: PostCategory.board,
                icon: Icon(Icons.forum_outlined),
                label: Text('게시판'),
              ),
              ButtonSegment(
                value: PostCategory.news,
                icon: Icon(Icons.campaign_outlined),
                label: Text('활동 소식'),
              ),
            ],
            selected: {_selectedCategory},
            onSelectionChanged: (v) =>
                setState(() => _selectedCategory = v.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),

        // ── 폼 입력 영역 ────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AuthorChip(isAnonymous: _isAnonymous),
                if (_isBoard)
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
                const SizedBox(height: 12),
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
