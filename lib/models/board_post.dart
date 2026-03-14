class BoardPost {
  final String id;
  final String title;
  final String summary;
  final String body; // 상세 내용
  final String imageUrl;
  final DateTime createdAt;

  const BoardPost({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.imageUrl,
    required this.createdAt,
  });
}
