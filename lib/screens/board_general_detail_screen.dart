import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../repository/board_repository.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../state/board_provider.dart';

/// 게시글 상세 + 댓글 화면 (Firestore 실시간)
class BoardGeneralDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const BoardGeneralDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<BoardGeneralDetailScreen> createState() =>
      _BoardGeneralDetailScreenState();
}

class _BoardGeneralDetailScreenState
    extends ConsumerState<BoardGeneralDetailScreen> {
  final _commentController = TextEditingController();
  bool _commentAnonymous = false;
  bool _submittingComment = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final user = AuthService.currentUser;
    if (user == null) {
      _showSnack('댓글을 작성하려면 로그인이 필요합니다.');
      return;
    }
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _submittingComment = true);
    try {
      final profile = await UserProfileRepository.getProfile(user.uid);
      final displayName = (profile?.displayName?.isNotEmpty == true)
          ? profile!.displayName!
          : (user.email?.split('@').first ?? '사용자');

      await BoardRepository.createComment(
        postId: widget.postId,
        body: _commentController.text,
        authorUid: user.uid,
        authorDisplayName: displayName,
        isAnonymous: _commentAnonymous,
      );
      _commentController.clear();
    } catch (e) {
      if (mounted) _showSnack('댓글 등록 실패: $e');
    } finally {
      if (mounted) setState(() => _submittingComment = false);
    }
  }

  Future<void> _deletePost() async {
    final ok = await _confirmDialog('게시글을 삭제하시겠습니까?');
    if (!ok) return;
    try {
      await BoardRepository.deletePost(widget.postId);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) _showSnack('삭제 실패: $e');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final ok = await _confirmDialog('댓글을 삭제하시겠습니까?');
    if (!ok) return;
    try {
      await BoardRepository.deleteComment(widget.postId, commentId);
    } catch (e) {
      if (mounted) _showSnack('삭제 실패: $e');
    }
  }

  Future<bool> _confirmDialog(String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('삭제')),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(boardPostProvider(widget.postId));
    final commentsAsync = ref.watch(boardCommentsProvider(widget.postId));
    final currentUid = AuthService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          postAsync.whenData((post) {
            if (post != null && post.authorUid == currentUid) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: '게시글 삭제',
                onPressed: _deletePost,
              );
            }
            return const SizedBox.shrink();
          }).value ??
              const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: postAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('오류: $e')),
              data: (post) {
                if (post == null) {
                  return const Center(child: Text('게시글을 찾을 수 없습니다.'));
                }
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 제목
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    // 작성자 / 날짜
                    Row(
                      children: [
                        Icon(
                          post.isAnonymous
                              ? Icons.visibility_off
                              : Icons.person,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.displayAuthor,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade700),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(post.createdAt),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    // 본문
                    Text(
                      post.body,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    // 댓글 섹션
                    Text(
                      '댓글',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 16),
                    commentsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('댓글 오류: $e'),
                      data: (comments) {
                        if (comments.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              '첫 번째 댓글을 남겨보세요.',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          );
                        }
                        return Column(
                          children: comments.map((c) {
                            final isMyComment = c.authorUid == currentUid;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    child: Icon(
                                      c.isAnonymous
                                          ? Icons.visibility_off
                                          : Icons.person,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              c.displayAuthor,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _formatDate(c.createdAt),
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      Colors.grey.shade500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(c.body),
                                      ],
                                    ),
                                  ),
                                  if (isMyComment)
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 16),
                                      visualDensity: VisualDensity.compact,
                                      tooltip: '댓글 삭제',
                                      onPressed: () => _deleteComment(c.id),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                );
              },
            ),
          ),
          // 댓글 입력 바
          _CommentInputBar(
            controller: _commentController,
            isAnonymous: _commentAnonymous,
            submitting: _submittingComment,
            onAnonymousChanged: (v) =>
                setState(() => _commentAnonymous = v),
            onSubmit: _submitComment,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return '방금';
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inDays < 1) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }
}

/// 댓글 입력 하단 바
class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isAnonymous;
  final bool submitting;
  final ValueChanged<bool> onAnonymousChanged;
  final VoidCallback onSubmit;

  const _CommentInputBar({
    required this.controller,
    required this.isAnonymous,
    required this.submitting,
    required this.onAnonymousChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 익명 체크
          Row(
            children: [
              SizedBox(
                height: 24,
                child: Checkbox(
                  value: isAnonymous,
                  onChanged: (v) => onAnonymousChanged(v ?? false),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const Text('익명', style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: AuthService.currentUser == null
                        ? '로그인 후 댓글을 남길 수 있습니다'
                        : '댓글을 입력하세요',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  enabled: AuthService.currentUser != null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: submitting ? null : onSubmit,
                icon: submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
