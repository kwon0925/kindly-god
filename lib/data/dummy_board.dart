import '../models/board_post.dart';

List<BoardPost> get dummyBoardPosts => [
  BoardPost(
    id: '1',
    title: '지역 센터 식량 지원',
    summary: '기여 포인트로 구매한 식량을 지역 센터에 전달했습니다.',
    body: '상세 내용: 2024년 3월 지역 센터에 식량을 지원했습니다. 기여 포인트가 실제 물품 구매에 사용되었음을 공개합니다.',
    imageUrl: 'assets/images/1.png',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  BoardPost(
    id: '2',
    title: '교육 자료 지원',
    summary: '청소년 교육 프로그램에 교재와 장비를 지원했습니다.',
    body: '상세 내용: 교육 자료 및 장비 구매 내역과 수혜 기관 정보를 공개합니다.',
    imageUrl: 'assets/images/2.png',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  BoardPost(
    id: '3',
    title: '의료 지원 활동',
    summary: '의료 취약 지역에 의료품을 지원했습니다.',
    body: '상세 내용: 의료품 구매 및 전달 내역을 공개합니다.',
    imageUrl: 'assets/images/3.png',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
];
