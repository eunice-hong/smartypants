import 'package:flutter/material.dart';
import 'package:smartypants/smartypants.dart';

import 'example_card.dart';
import 'example_data.dart';

/// A tab that displays preset transformation examples grouped by category.
class ExamplesTab extends StatelessWidget {
  /// Called when the user taps "Try it" on an example card.
  final void Function(String, SmartyPantsConfig?)? onTryExample;

  const ExamplesTab({super.key, this.onTryExample});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: exampleCategories.length,
      itemBuilder: (context, index) {
        final category = exampleCategories[index];
        return _CategorySection(
          category: category,
          colorScheme: colorScheme,
          theme: theme,
          onTryExample: onTryExample,
        );
      },
    );
  }
}

class _CategorySection extends StatelessWidget {
  final ExampleCategory category;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final void Function(String, SmartyPantsConfig?)? onTryExample;

  const _CategorySection({
    required this.category,
    required this.colorScheme,
    required this.theme,
    this.onTryExample,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      category.summary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Example cards
          ...category.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ExampleCard(
                item: item,
                config: category.config,
                onTryIt: onTryExample != null
                    ? () => onTryExample!(
                        item.input, item.config ?? category.config)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
