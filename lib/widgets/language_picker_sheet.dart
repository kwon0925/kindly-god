import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';

import '../config/supported_locales.dart';
import '../state/locale_provider.dart';

/// ?? ??? ???? ?? ?? ??
/// [profileLocked] ??? ???? ?? ???
class LanguagePickerTile extends ConsumerWidget {
  const LanguagePickerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final info = localeInfoByCode(locale.languageCode);

    return InkWell(
      onTap: () => _showSheet(context, ref, locale),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(info.flagEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                info.nativeName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, WidgetRef ref, Locale current) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _LanguagePickerSheet(
        currentCode: current.languageCode,
        onSelected: (code) {
          ref.read(localeProvider.notifier).setLocale(Locale(code));
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).languageChanged),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  final String currentCode;
  final ValueChanged<String> onSelected;

  const _LanguagePickerSheet({
    required this.currentCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.selectLanguage,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: kSupportedLocales.length,
            itemBuilder: (_, i) {
              final info = kSupportedLocales[i];
              final isSelected = info.code == currentCode;
              return ListTile(
                leading: Text(info.flagEmoji, style: const TextStyle(fontSize: 22)),
                title: Text(
                  info.nativeName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20)
                    : null,
                onTap: () => onSelected(info.code),
              );
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
      ],
    );
  }
}
