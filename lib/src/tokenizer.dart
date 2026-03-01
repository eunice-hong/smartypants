part of 'smartypants_base.dart';

enum _TokenType { text, html }

class _Token {
  final _TokenType type;
  final String content;

  _Token(this.type, this.content);

  @override
  String toString() => '_Token($type, "$content")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Token &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          content == other.content;

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}

List<_Token> _tokenize(String input) {
  final tokens = <_Token>[];
  final scanner = _Scanner(input);
  final textBuffer = StringBuffer();

  void flushText() {
    if (textBuffer.isNotEmpty) {
      tokens.add(_Token(_TokenType.text, textBuffer.toString()));
      textBuffer.clear();
    }
  }

  while (!scanner.isDone) {
    if (scanner.peek() == '<') {
      final token = scanner.scanTag();
      if (token != null) {
        flushText();
        tokens.add(token);
        continue;
      }
      // Not a tag, consume '<' as text
      textBuffer.write('<');
      scanner.advance();
      continue;
    }

    final text = scanner.scanText();
    textBuffer.write(text);
  }

  flushText();
  return tokens;
}

class _Scanner {
  final String _input;
  int _index = 0;

  _Scanner(this._input);

  bool get isDone => _index >= _input.length;

  String peek() => isDone ? '' : _input[_index];

  _Token? scanTag() {
    // Save state to backtrack if not a valid tag
    final start = _index;

    if (peek() != '<') return null;
    advance(); // Consume '<'

    // Check for closing slash
    bool isClosing = false;
    if (peek() == '/') {
      isClosing = true;
      advance();
    }

    // Check strict start of tag name
    // Must start with letter, !, or ? (for comments/doctype)
    if (isDone || !(peek().contains(RegExp(r'[a-zA-Z!?]')))) {
      _index = start;
      return null;
    }

    // Scan tag name
    final nameStart = _index;
    while (!isDone &&
        (peek().contains(RegExp(r'[a-zA-Z0-9!?]')) ||
            peek() == ':' ||
            peek() == '_' ||
            peek() == '-')) {
      advance();
    }
    final tagName = _input.substring(nameStart, _index).toLowerCase();

    if (tagName.isEmpty) {
      // Not a tag (e.g. '< 3')
      _index = start;
      return null;
    }

    if (tagName == '!--') {
      // HTML Comment: scan until -->
      final commentEnd = _input.indexOf('-->', _index);
      if (commentEnd != -1) {
        _index = commentEnd + 3;
        return _Token(_TokenType.html, _input.substring(start, _index));
      } else {
        // Unclosed comment, consume rest of input? or strict fail?
        // Browsers often consume rest of input.
        _index = _input.length;
        return _Token(_TokenType.html, _input.substring(start));
      }
    }

    // Scan attributes until '>'
    while (!isDone && peek() != '>') {
      final char = peek();
      if (char == '"' || char == "'") {
        scanQuoted(char);
      } else {
        advance();
      }
    }

    if (isDone) {
      // Incomplete tag, treat as text? Or just return what we have?
      // For now, if we don't find '>', backtrack and treat as text
      _index = start;
      return null;
    }

    advance(); // Consume '>'
    final tagContent = _input.substring(start, _index);

    // Check for special tags that capture content (script, style, pre, code, kbd, math)
    // Only if it's an opening tag
    if (!isClosing && _isSpecialTag(tagName)) {
      // Smart search for closing tag allowing whitespace: </tagName\s*>
      final closingPattern = RegExp('</$tagName\\s*>', caseSensitive: false);
      // We search in the substring starting from current index
      final match = closingPattern.firstMatch(_input.substring(_index));

      if (match != null) {
        // match.end is relative to the substring start (_index)
        _index += match.end;
        return _Token(_TokenType.html, _input.substring(start, _index));
      } else {
        // Unclosed special tag, consume rest of input to avoid transforming content
        _index = _input.length;
        return _Token(_TokenType.html, _input.substring(start));
      }
    }

    return _Token(_TokenType.html, tagContent);
  }

  String scanText() {
    final start = _index;
    while (!isDone && peek() != '<') {
      advance();
    }
    return _input.substring(start, _index);
  }

  void scanQuoted(String quote) {
    advance(); // Consume opening quote
    while (!isDone && peek() != quote) {
      if (peek() == '\\') {
        advance(); // Skip escape
        if (!isDone) advance();
      } else {
        advance();
      }
    }
    if (!isDone) advance(); // Consume closing quote
  }

  void advance() {
    _index++;
  }

  bool _isSpecialTag(String tagName) {
    const specialTags = {
      'script',
      'style',
      'pre',
      'code',
      'kbd',
      'math',
      'textarea'
    };
    return specialTags.contains(tagName);
  }
}
