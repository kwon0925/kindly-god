import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../data/heaven_options.dart';
import '../models/religion.dart';
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
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_religion == null || _baseWorld == null || _location == null ||
        _vibe == null || _visualEffect == null || _specialPerk == null) {
      _showSnack(l10n.selectAllRequired);
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
      if (mounted) _showSnack('${l10n.registerFailed}: $e');
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
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0f3460),
        foregroundColor: Colors.white,
        title: Text(l10n.heavenPurchaseTitle),
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
              _sectionHeader('👤 ${l10n.basicInfo}'),
              const SizedBox(height: 12),

              _inputField(
                controller: _nameController,
                label: '${l10n.nameLabel} *',
                hint: l10n.nameHint,
                validator: (v) => (v?.trim().isEmpty ?? true) ? l10n.enterName : null,
              ),
              const SizedBox(height: 12),

              // ── 종교 선택 ──
              _dropdownField<String>(
                label: '${l10n.selectReligion} *',
                value: _religion,
                items: defaultReligions
                    .map((r) => DropdownMenuItem(
                          value: r.id,
                          child: Text(r.displayName(lang)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _religion = v),
              ),
              const SizedBox(height: 24),

              _sectionHeader('🌍 ${l10n.styleSettings}'),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '1. ${l10n.baseWorld} *',
                value: _baseWorld,
                items: HeavenOptions.baseWorlds
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _baseWorld = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '2. ${l10n.locationLabel} *',
                value: _location,
                items: HeavenOptions.locations
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _location = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '3. ${l10n.vibeLabel} *',
                value: _vibe,
                items: HeavenOptions.vibes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _vibe = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '4. ${l10n.visualLabel} *',
                value: _visualEffect,
                items: HeavenOptions.visualEffects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _visualEffect = v),
              ),
              const SizedBox(height: 12),

              _dropdownField<String>(
                label: '5. ${l10n.specialPerksLabel} *',
                value: _specialPerk,
                items: HeavenOptions.specialPerks
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _specialPerk = v),
              ),
              const SizedBox(height: 24),

              _sectionHeader('📮 ${l10n.shippingInfo}'),
              const SizedBox(height: 12),

              _inputField(
                controller: _countryController,
                label: '${l10n.countryType} *',
                hint: l10n.countryHint,
                validator: (v) => (v?.trim().isEmpty ?? true) ? l10n.enterCountry : null,
              ),
              const SizedBox(height: 12),
              _inputField(
                controller: _addressController,
                label: '${l10n.addressLabel} *',
                hint: l10n.addressHint,
                maxLines: 2,
                validator: (v) => (v?.trim().isEmpty ?? true) ? l10n.enterAddress : null,
              ),
              const SizedBox(height: 12),
              _inputField(
                controller: _contactController,
                label: '${l10n.contactLabel} *',
                hint: l10n.contactHint,
                validator: (v) => (v?.trim().isEmpty ?? true) ? l10n.enterContact : null,
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
                  '💛  ${l10n.heavenDonationNoticeShort}',
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
                    _submitting ? l10n.processing : '✨ ${l10n.buyHeavenLand}',
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
      validator: (v) => v == null ? AppLocalizations.of(context).pleaseSelect : null,
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
