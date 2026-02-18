import 'package:flutter/material.dart';
import 'package:smartypants/smartypants.dart';

/// A tab that lets users type text and see real-time SmartyPants transformations.
class PlaygroundTab extends StatefulWidget {
  /// Optional initial text to pre-fill the input field.
  final String? initialText;

  const PlaygroundTab({super.key, this.initialText});

  @override
  State<PlaygroundTab> createState() => PlaygroundTabState();
}

class PlaygroundTabState extends State<PlaygroundTab> {
  final TextEditingController _controller = TextEditingController();
  String _formattedText = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
      _formattedText = SmartyPants.formatText(widget.initialText!);
    }
  }

  /// Sets the input text programmatically (e.g. from an example card).
  void setInput(String text) {
    _controller.text = text;
    setState(() {
      _formattedText = SmartyPants.formatText(text);
    });
  }

  void _onTextChanged(String value) {
    setState(() {
      _formattedText = value.isEmpty ? '' : SmartyPants.formatText(value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input section
          Text(
            'Input',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            onChanged: _onTextChanged,
            maxLines: 5,
            minLines: 3,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
            decoration: InputDecoration(
              hintText: 'Type something... e.g. "Hello" -- it\'s great...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 24),

          // Result section
          Text(
            'Result',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _formattedText.isEmpty
                  ? Center(
                      key: const ValueKey('empty'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 48,
                            color:
                                colorScheme.onSurfaceVariant.withOpacity(0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Type something above to see the result',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      key: const ValueKey('result'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primaryContainer,
                        ),
                      ),
                      child: SelectableText(
                        _formattedText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          height: 1.6,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
