import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/religion.dart';
import '../state/test_point_provider.dart';

class ReligionDetailScreen extends ConsumerWidget {
  final String religionId;

  const ReligionDetailScreen({super.key, required this.religionId});

  Religion get _religion {
    return defaultReligions.firstWhere(
      (r) => r.id == religionId,
      orElse: () => defaultReligions.first,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = _religion;
    final points = ref.watch(testPointProvider).state.getReligionPoints(r.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(r.name),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      Religion.symbol(r.id),
                      style: TextStyle(fontSize: 64, height: 1.1, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(r.name, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('$points P', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.support),
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text('이 종교 응원하기'),
                ),
              ),
              const SizedBox(height: 24),
              Text('활동 소식', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '응원 포인트로 진행된 활동 소식을 게시판에서 확인할 수 있습니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push(AppRoutes.board),
                child: const Text('활동 소식 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
