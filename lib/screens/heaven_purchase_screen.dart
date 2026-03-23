import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/heaven_options.dart';
import '../models/heaven_order.dart';
import '../services/auth_service.dart';
import 'heaven_complete_screen.dart';

/// 천국 영토 구매 상세 화면
class HeavenPurchaseScreen extends StatefulWidget {
  const HeavenPurchaseScreen({super.key});

  @override
  State<HeavenPurchaseScreen> createState() => _HeavenPurchaseScreenState();
}

class _HeavenPurchaseScreenState extends State<HeavenPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController    = TextEditingController();
  final _countryController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  String? _religion;
  String? _baseWorld;
  String? _location;
  String? _vibe;
  String? _visualEffect;
  String? _specialPerk;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_religion == null || _baseWorld == null || _location == null ||
        _vibe == null || _visualEffect == null || _specialPerk == null) {
      _showSnack('모든 항목을 선택해 주세요.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final uid = AuthService.currentUser?.uid ?? 'guest';
      final ref = FirebaseFirestore.instance.collection('heavenOrders').doc();

      final order = HeavenOrder(
        id: ref.id,
        uid: uid,
        name: _nameController.text.trim(),
        religion: _religion!,
        baseWorld: _baseWorld!,
        location: _location!,
        vibe: _vibe!,
        visualEffect: _visualEffect!,
        specialPerk: _specialPerk!,
        country: _countryController.text.trim(),
        address: _addressController.text.trim(),
        contact: _contactController.text.trim(),
        createdAt: DateTime.now(),
      );

      await ref.set(order.toFirestore());

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HeavenCompleteScreen(order: order),
          ),
        );
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
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: const Text('천국 영토 구매'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('👤 기본 정보'),
              const SizedBox(height: 12),

              _inputField(
                controller: _nameController,
                label: '이름 *',
                hint: '소유자 이름을 입력하세요',
                validator: (v) => (v?.trim().isEmpty ?? true) ? '이름을 입력해 주세요.' : null,
              ),
              const SizedBox(height: 12),

              // ── 종교 선택 ──
              _dropdownField<String>(
                label: '종교 선택 *',
                value: _religion,
                items: HeavenOptions.religions
                    .map((r) => DropdownMenuItem(
                          value: r['id'],
                          child: Text(r['label']!),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _religion = v),
              ),
              const SizedBox(height: 24),

              _sectionHeader('🌍 스타일 설정'),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '1. 세계관 및 종교 (Base World) *',
                value: _baseWorld,
                items: HeavenOptions.baseWorlds
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _baseWorld = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '2. 입지 및 지형 (Location) *',
                value: _location,
                items: HeavenOptions.locations
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _location = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '3. 분위기 및 구성 요소 (Vibe) *',
                value: _vibe,
                items: HeavenOptions.vibes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _vibe = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '4. 시각적/감각적 효과 (Visual) *',
                value: _visualEffect,
                items: HeavenOptions.visualEffects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _visualEffect = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '5. 특별 서비스 (Special Perks) *',
                value: _specialPerk,
                items: HeavenOptions.specialPerks
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _specialPerk = v),
              ),
              const SizedBox(height: 24),

              _sectionHeader('📮 발송 정보'),
              const SizedBox(height: 12),

              _inputField(
                controller: _countryController,
                label: '국가 *',
                hint: '예: 대한민국',
                validator: (v) => (v?.trim().isEmpty ?? true) ? '국가를 입력해 주세요.' : null,
              ),
              const SizedBox(height: 12),
              _inputField(
                controller: _addressController,
                label: '주소 *',
                hint: '증명서를 받을 상세 주소',
                maxLines: 2,
                validator: (v) => (v?.trim().isEmpty ?? true) ? '주소를 입력해 주세요.' : null,
              ),
              const SizedBox(height: 12),
              _inputField(
                controller: _contactController,
                label: '연락처 *',
                hint: '전화번호 또는 이메일',
                validator: (v) => (v?.trim().isEmpty ?? true) ? '연락처를 입력해 주세요.' : null,
              ),
              const SizedBox(height: 32),

              // 기부 안내
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.indigo.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade300.withAlpha(80)),
                ),
                child: Text(
                  '💛  이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.',
                  style: TextStyle(
                    color: Colors.indigo.shade100,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 결제 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                  ),
                  icon: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.star),
                  label: Text(
                    _submitting ? '처리 중...' : '✨ 천국 영토 구매하기',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) => Text(
        text,
        style: TextStyle(
          color: Colors.amber.shade300,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withAlpha(15),
      ),
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: (v) => v == null ? '선택해 주세요.' : null,
      dropdownColor: const Color(0xFF0f3460),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white.withAlpha(15),
      ),
    );
  }
}
