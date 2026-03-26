import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RuleText extends StatelessWidget {
  const RuleText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withAlpha((0.7 * 255).round()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.remove_red_eye_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loc.ruleTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              loc.ruleSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer
                      .withAlpha((0.8 * 255).round()),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "${loc.ruleEvery20Minutes} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${loc.ruleLookAway} ",
                  ),
                  TextSpan(
                    text: "${loc.rule20FeetAway} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "${loc.ruleFor} "),
                  TextSpan(
                    text: loc.rule20Seconds,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: loc.ruleExplanation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
