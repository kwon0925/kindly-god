/// PostListWidget / BoardRepository 필터 파라미터
/// religion null = 전체(메인), category null = 전체(미지정 시 board로 처리 가능)
class PostListFilter {
  final String? religion;
  final String? category;
  final int limit;

  const PostListFilter({
    this.religion,
    this.category,
    this.limit = 30,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostListFilter &&
          religion == other.religion &&
          category == other.category &&
          limit == other.limit;

  @override
  int get hashCode => Object.hash(religion, category, limit);
}
