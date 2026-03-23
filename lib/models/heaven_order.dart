import 'package:cloud_firestore/cloud_firestore.dart';

/// 천국 영토 구매 주문 모델
class HeavenOrder {
  final String id;
  final String uid;         // 구매자 Firebase uid
  final String name;        // 구매자 이름
  final String religion;    // 선택 종교 id
  final String baseWorld;   // 세계관/종교 테마
  final String location;    // 입지/지형
  final String vibe;        // 분위기/구성
  final String visualEffect;// 시각·감각 효과
  final String specialPerk; // 특별 서비스
  final String country;     // 국가
  final String address;     // 주소
  final String contact;     // 연락처
  final DateTime createdAt;

  const HeavenOrder({
    required this.id,
    required this.uid,
    required this.name,
    required this.religion,
    required this.baseWorld,
    required this.location,
    required this.vibe,
    required this.visualEffect,
    required this.specialPerk,
    required this.country,
    required this.address,
    required this.contact,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'name': name,
    'religion': religion,
    'baseWorld': baseWorld,
    'location': location,
    'vibe': vibe,
    'visualEffect': visualEffect,
    'specialPerk': specialPerk,
    'country': country,
    'address': address,
    'contact': contact,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory HeavenOrder.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return HeavenOrder(
      id: doc.id,
      uid: d['uid'] as String? ?? '',
      name: d['name'] as String? ?? '',
      religion: d['religion'] as String? ?? '',
      baseWorld: d['baseWorld'] as String? ?? '',
      location: d['location'] as String? ?? '',
      vibe: d['vibe'] as String? ?? '',
      visualEffect: d['visualEffect'] as String? ?? '',
      specialPerk: d['specialPerk'] as String? ?? '',
      country: d['country'] as String? ?? '',
      address: d['address'] as String? ?? '',
      contact: d['contact'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
