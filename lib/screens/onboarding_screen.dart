import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/religion.dart';
import '../models/country.dart';
import '../state/test_point_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  Religion? _selectedReligion;
  Country? _selectedCountry;

  void _next() {
    if (_step == 0 && _selectedReligion != null) {
      setState(() => _step = 1);
      return;
    }
    if (_step == 1 && _selectedCountry != null) {
      ref.read(testPointProvider).setOnboardingChoice(_selectedReligion!.id, _selectedCountry!.id);
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시작하기')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _step == 0 ? _buildReligionStep() : _buildCountryStep(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: (_step == 0 && _selectedReligion != null) || (_step == 1 && _selectedCountry != null)
                ? _next
                : null,
            child: Text(_step == 0 ? '다음' : '시작하기'),
          ),
        ),
      ),
    );
  }

  Widget _buildReligionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '응원할 종교를 선택하세요',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '세계 10대 종교 중 선택하거나, 나중에 기타로 참여할 수 있습니다.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: defaultReligions.map((r) {
                final selected = _selectedReligion?.id == r.id;
                return FilterChip(
                  label: Text(r.name),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedReligion = r),
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '국가를 선택하세요',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '국가별 랭킹에 반영됩니다.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: defaultCountries.map((c) {
              final selected = _selectedCountry?.id == c.id;
              return ListTile(
                title: Text('${c.name} (${c.nameEn})'),
                trailing: selected ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32)) : null,
                selected: selected,
                onTap: () => setState(() => _selectedCountry = c),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
