import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 및 안내'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: '서비스 성격',
              children: [
                '본 서비스는 비영리단체가 아니며, 기부금 영수증 발급 대상이 아닙니다.',
                '포인트는 응원·기여 참여의 기록이며, 현금 환급 및 기부금 영수증 발급 대상이 아닙니다.',
              ],
            ),
            const SizedBox(height: 24),
            _Section(
              title: '수익 사용',
              children: [
                '광고 수익 일부는 사회에 도움이 되는 활동에 사용됩니다.',
                '본 서비스는 기부단체가 아니며, 수익 일부를 사회공헌 목적의 후원 또는 활동에 사용할 수 있습니다.',
              ],
            ),
            const SizedBox(height: 24),
            _Section(
              title: '응원 포인트',
              children: [
                '결제(예: 100달러) 시 해당 금액만큼 포인트(100P)가 적립되며, 선택한 종교·계정·국가 랭킹에 귀속됩니다.',
                '광고 시청 시 정해진 조건에 따라 포인트가 적립됩니다.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...children.map((text) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        )),
      ],
    );
  }
}
