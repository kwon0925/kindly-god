import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/religion.dart';
import '../models/ranking.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';
import '../widgets/donation_blessing_dialog.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _customAmountController = TextEditingController();
  static const quickAmounts = [1, 10, 100, 1000];
  int? _selectedAmount;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _doPay() {
    if (_selectedAmount == null || _selectedAmount! <= 0) return;
    _onPay(_selectedAmount!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('응원하기'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '포인트로 응원하기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '1달러 = 1포인트. 금액을 선택한 뒤 결제 버튼을 누르면 반영됩니다.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...quickAmounts.map((amount) => _AmountChip(
                  amount: amount,
                  selected: _selectedAmount == amount,
                  onTap: () => setState(() => _selectedAmount = amount),
                )),
                FilterChip(
                  label: const Text('기타'),
                  selected: _selectedAmount != null && !quickAmounts.contains(_selectedAmount),
                  onSelected: (_) => _showCustomAmountDialog(context),
                ),
              ],
            ),
            if (_selectedAmount != null && _selectedAmount! > 0) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _doPay,
                  icon: const Icon(Icons.payment),
                  label: Text('결제 (\$$_selectedAmount → $_selectedAmount P)'),
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              '광고 시청으로 응원하기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '전면 광고를 클릭 후 시청하면 계정당 1포인트가 적립됩니다.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              '10회 마다 10포인트 추가 적립',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _onAdWatch,
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('광고 시청하고 1P 받기'),
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 안내',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('결제는 PayPal로 진행됩니다. 포인트는 현금 환급 및 기부금 영수증 발급 대상이 아닙니다.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAdWatch() async {
    final user = AuthService.currentUser;
    if (user != null) {
      final profile = await UserProfileRepository.getProfile(user.uid);
      if (profile == null || !profile.profileLocked || profile.religionId == null || profile.countryId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('계정에서 아이디·종교·국가를 설정하고 "종교·국가 저장"을 한 뒤 이용해 주세요.'),
            ),
          );
        }
        return;
      }
      await UserProfileRepository.addAdWatchPoints(user.uid);
      // 기간별 계정 랭킹 캐시 즉시 무효화
      for (final period in RankingPeriod.values) {
        ref.invalidate(accountRankingByPeriodProvider(period));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('1 P 적립됨 (10회마다 10 P 추가)')),
        );
        await _showDonationBlessing(profile.religionId!);
      }
      return;
    }
    final notifier = ref.read(testPointProvider);
    final state = notifier.state;
    if (state.currentTestUser == null || state.selectedReligionId == null || state.selectedCountryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('테스트: 계정·종교·국가를 선택한 뒤 이용해 주세요.')),
        );
      }
      return;
    }
    final ok = notifier.addPoints(1);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('1 P 적립됨 (테스트)')),
      );
      await _showDonationBlessing(state.selectedReligionId!);
    }
  }

  Future<void> _onPay(int amount) async {
    final user = AuthService.currentUser;
    if (user != null) {
      final profile = await UserProfileRepository.getProfile(user.uid);
      if (profile == null || !profile.profileLocked) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('계정(사람 아이콘)에서 아이디·종교·국가를 설정하고 "종교·국가 저장"을 한 뒤 이용해 주세요.'),
            ),
          );
        }
        return;
      }
      if (profile.religionId == null || profile.countryId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('종교와 국가를 선택한 뒤 저장해 주세요.')),
          );
        }
        return;
      }
      await UserProfileRepository.addPoints(user.uid, amount);
      // 기간별 계정 랭킹 캐시 즉시 무효화
      for (final period in RankingPeriod.values) {
        ref.invalidate(accountRankingByPeriodProvider(period));
      }
      if (mounted) {
        setState(() => _selectedAmount = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$amount P 적립됨 (계정·종교·국가 랭킹에 반영됩니다)')),
        );
        await _showDonationBlessing(profile.religionId!);
      }
      return;
    }
    final notifier = ref.read(testPointProvider);
    final state = notifier.state;
    if (state.currentTestUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사람 아이콘에서 테스트 유저(A/B/C)를 먼저 선택하세요')),
      );
      return;
    }
    if (state.selectedReligionId == null || state.selectedCountryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정(사람 아이콘)에서 종교·국가를 선택한 뒤 이용해 주세요')),
      );
      return;
    }
    final ok = notifier.addPoints(amount);
    if (ok && mounted) {
      setState(() => _selectedAmount = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$amount P 적립됨 (유저 ${state.currentTestUser}, 종교·국가 반영)')),
      );
      await _showDonationBlessing(state.selectedReligionId!);
    }
  }

  Future<void> _showDonationBlessing(String religionId) async {
    final imagePath = Religion.donationImagePath(religionId);
    if (imagePath == null || !mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DonationBlessingDialog(imageAssetPath: imagePath),
    );
  }

  void _showCustomAmountDialog(BuildContext context) {
    _customAmountController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('금액 입력'),
        content: TextField(
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '금액 (USD)',
            hintText: '예: 50',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('취소')),
          FilledButton(
            onPressed: () {
              final text = _customAmountController.text;
              final amount = int.tryParse(text);
              Navigator.pop(ctx);
              if (amount != null && amount > 0) setState(() => _selectedAmount = amount);
            },
            child: const Text('선택'),
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final int amount;
  final bool selected;
  final VoidCallback onTap;

  const _AmountChip({required this.amount, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text('\$$amount'),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
