import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';

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
              '전면 광고를 클릭 후 시청하면 계정당 1포인트가 적립됩니다. 10회 시청 시 추가 10포인트 보너스.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: 애드센스 전면광고 연동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('광고 연동 후 시청 가능합니다')),
                  );
                },
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

  Future<void> _onPay(int amount) async {
    final user = AuthService.currentUser;
    if (user != null) {
      await UserProfileRepository.addPoints(user.uid, amount);
      // StreamProvider 사용으로 Firestore 변경 시 자동 반영 — invalidate 불필요
      if (mounted) {
        setState(() => _selectedAmount = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$amount P 적립됨 (계정·종교·국가 랭킹에 반영됩니다)')),
        );
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
    }
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
