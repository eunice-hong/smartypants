import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartypants/smartypants.dart';

import 'smartypants_formatter.dart';

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
  bool _useFormatter = false;
  SmartyPantsConfig? _config;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _controller.text = widget.initialText!;
      _formattedText =
          SmartyPants.formatText(widget.initialText!, config: _config);
    }
  }

  /// Sets the input text programmatically (e.g. from an example card).
  void setInput(String text, {SmartyPantsConfig? config}) {
    _controller.text = text;
    setState(() {
      _config = config;
      _formattedText = SmartyPants.formatText(text, config: _config);
    });
  }

  void _onTextChanged(String value) {
    // Always trigger a rebuild so that UI elements depending on _controller.text
    // (like the clear button visibility) can update.
    setState(() {
      if (!_useFormatter) {
        _formattedText =
            value.isEmpty ? '' : SmartyPants.formatText(value, config: _config);
      }
    });
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _formattedText = '';
      _config = null;
    });
  }

  void _copyResult() {
    if (_formattedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _formattedText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
    final hasText = _controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input header + Formatter toggle
          Row(
            children: [
              Text(
                'Input',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Live Format',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 24,
                child: Switch.adaptive(
                  value: _useFormatter,
                  onChanged: (value) {
                    setState(() {
                      _useFormatter = value;
                      if (!value) {
                        _formattedText = _controller.text.isEmpty
                            ? ''
                            : SmartyPants.formatText(_controller.text,
                                config: _config);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            onChanged: _onTextChanged,
            maxLines: 5,
            minLines: 3,
            inputFormatters: _useFormatter
                ? <TextInputFormatter>[SmartypantsFormatter(config: _config)]
                : null,
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
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: _clearInput,
                      tooltip: 'Clear',
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Result header + Copy button
          Row(
            children: [
              Text(
                _useFormatter ? 'Live Format Mode' : 'Result',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_formattedText.isNotEmpty && !_useFormatter)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  onPressed: _copyResult,
                  tooltip: 'Copy result',
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _useFormatter
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_fix_high_rounded,
                          size: 48,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Text is formatted as you type.\n'
                          'The input field itself shows the result!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme.onSurfaceVariant.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : AnimatedSwitcher(
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
                                  color: colorScheme.onSurfaceVariant
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Type something above to see the result',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            key: const ValueKey('result'),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.primaryContainer.withOpacity(0.2),
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
