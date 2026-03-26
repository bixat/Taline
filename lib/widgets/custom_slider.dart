import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final int value;
  final String title;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.min = 1,
    this.max = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$value',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.primaryContainer,
            thumbColor: theme.colorScheme.primary,
            overlayColor:
                theme.colorScheme.primary.withAlpha((0.12 * 255).round()),
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6.0,
              elevation: 2.0,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 16.0,
            ),
          ),
          child: Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            divisions: 50,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
