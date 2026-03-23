import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';

import '../services/translation_service.dart';
import '../state/locale_provider.dart';

/// ???·?? ?? ??? ???? ?? ?? ??
///
/// - ?? ?? == ?? ??: ?? (?? ???)
/// - ? ??:  "? ?? ? ?? ??" ?? ???
/// - ???:   ????? ML Kit ?? ?? (?? ??)
class TranslateButton extends ConsumerStatefulWidget {
  final String text;
  final String sourceLanguageCode;
  final Widget Function(String displayText) builder;

  const TranslateButton({
    super.key,
    required this.text,
    required this.builder,
    this.sourceLanguageCode = 'ko',
  });

  @override
  ConsumerState<TranslateButton> createState() => _TranslateButtonState();
}

class _TranslateButtonState extends ConsumerState<TranslateButton> {
  TranslationResult _result = TranslationResult.idle;
  bool _showTranslated = false;

  Future<void> _toggle() async {
    final locale = ref.read(localeProvider);
    final targetCode = locale.languageCode;

    if (_showTranslated) {
      setState(() => _showTranslated = false);
      return;
    }

    if (_result.isSuccess) {
      setState(() => _showTranslated = true);
      return;
    }

    if (!TranslationService.instance.isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translationUnavailable),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: AppLocalizations.of(context).close,
              onPressed: () {},
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _result = const TranslationResult(status: TranslationStatus.loading);
    });

    final result = await TranslationService.instance.translate(
      text: widget.text,
      targetCode: targetCode,
      sourceCode: widget.sourceLanguageCode,
    );

    if (!mounted) return;
    setState(() {
      _result = result;
      if (result.isSuccess) _showTranslated = true;
    });

    if (!result.isSuccess && result.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final targetCode = locale.languageCode;

    // ?? ?? == ?? ??: ?? ?? ??? ??
    if (targetCode == widget.sourceLanguageCode) {
      return widget.builder(widget.text);
    }

    final l10n = AppLocalizations.of(context);
    final displayText = (_showTranslated && _result.translatedText != null)
        ? _result.translatedText!
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.builder(displayText),
        const SizedBox(height: 6),
        _TranslateChip(
          status: _result.status,
          showingTranslated: _showTranslated,
          l10n: l10n,
          onTap: _toggle,
        ),
      ],
    );
  }
}

/// ?? ??? ???? ?? ? ??
class _TranslateChip extends StatelessWidget {
  final TranslationStatus status;
  final bool showingTranslated;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _TranslateChip({
    required this.status,
    required this.showingTranslated,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    String label;
    Widget? leading;

    switch (status) {
      case TranslationStatus.loading:
        label = l10n.translating;
        leading = SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: colorScheme.primary),
        );
      case TranslationStatus.unsupported:
        label = l10n.translationUnavailable;
        leading = const Icon(Icons.info_outline, size: 14);
      default:
        label = showingTranslated ? l10n.showOriginal : l10n.translate;
        leading = Icon(
          showingTranslated ? Icons.undo : Icons.translate,
          size: 14,
          color: colorScheme.primary,
        );
    }

    return InkWell(
      onTap: status == TranslationStatus.loading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 4)],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
