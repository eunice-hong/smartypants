import 'package:flutter/material.dart';
import 'package:smartypants/smartypants.dart';

import 'example_data.dart';

/// A card widget that displays a single before/after transformation example.
class ExampleCard extends StatelessWidget {
  final ExampleItem item;
  final VoidCallback? onTryIt;

  const ExampleCard({
    super.key,
    required this.item,
    this.onTryIt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formatted = SmartyPants.formatText(item.input);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTryIt,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.description,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (onTryIt != null)
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: colorScheme.primary.withOpacity(0.6),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Before
              _TransformRow(
                label: 'Before',
                text: item.input,
                backgroundColor:
                    colorScheme.surfaceContainerHighest.withOpacity(0.5),
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),

              // Arrow
              Center(
                child: Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: colorScheme.primary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),

              // After
              _TransformRow(
                label: 'After',
                text: formatted,
                backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransformRow extends StatelessWidget {
  final String label;
  final String text;
  final Color backgroundColor;
  final TextStyle? textStyle;

  const _TransformRow({
    required this.label,
    required this.text,
    required this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
