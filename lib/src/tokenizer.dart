/// The type of a [Token]: either raw text, an HTML tag/element, or a Markdown
/// code region.
enum TokenType {
  /// Plain text content that is not part of an HTML tag.
  text,

  /// An HTML tag, comment, or special element (e.g. `<b>`, `<!-- ... -->`).
  html,

  /// A Markdown inline code span (e.g. `` `code` ``, ` ``code`` `) or fenced
  /// code block (e.g. ` ``` `, `~~~`). Content inside is never transformed.
  markdown,
}

/// A single unit produced by [tokenize], representing either a span of plain
/// text or an HTML tag/element.
class Token {
  /// The kind of content this token holds.
  final TokenType type;

  /// The raw string content of this token.
  final String content;

  /// Creates a token with the given [type] and [content].
  Token(this.type, this.content);

  @override
  String toString() => 'Token($type, "$content")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Token &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          content == other.content;

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}

/// Splits [input] into a list of [Token]s, alternating between plain-text
/// spans, HTML tags/elements, and Markdown code regions.
///
/// Special HTML tags (`<script>`, `<style>`, `<pre>`, `<code>`, `<kbd>`,
/// `<math>`, `<textarea>`) and their inner content are returned as a single
/// [TokenType.html] token so that SmartyPants transformations are not applied
/// inside them.
///
/// Markdown inline code spans (`` `code` ``, ` ``code`` `) and fenced code
/// blocks (` ``` `, `~~~`) are returned as [TokenType.markdown] tokens and are
/// likewise excluded from transformations.
List<Token> tokenize(String input) {
  final tokens = <Token>[];
  final scanner = _Scanner(input);
  final textBuffer = StringBuffer();

  void flushText() {
    if (textBuffer.isNotEmpty) {
      tokens.add(Token(TokenType.text, textBuffer.toString()));
      textBuffer.clear();
    }
  }

  while (!scanner.isDone) {
    final ch = scanner.peek();

    if (ch == '<') {
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

    if (ch == '`' || ch == '~') {
      final token = scanner.scanMarkdown();
      if (token != null) {
        flushText();
        tokens.add(token);
        continue;
      }
      // Not a Markdown code region, consume the character as text
      textBuffer.write(ch);
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

  Token? scanTag() {
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
    if (isDone || !_isTagStartChar(_input.codeUnitAt(_index))) {
      _index = start;
      return null;
    }

    // Scan tag name
    final nameStart = _index;
    while (!isDone &&
        (_isTagNameChar(_input.codeUnitAt(_index)) ||
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
        return Token(TokenType.html, _input.substring(start, _index));
      } else {
        // Unclosed comment, consume rest of input? or strict fail?
        // Browsers often consume rest of input.
        _index = _input.length;
        return Token(TokenType.html, _input.substring(start));
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
        return Token(TokenType.html, _input.substring(start, _index));
      } else {
        // Unclosed special tag, consume rest of input to avoid transforming content
        _index = _input.length;
        return Token(TokenType.html, _input.substring(start));
      }
    }

    return Token(TokenType.html, tagContent);
  }

  String scanText() {
    final start = _index;
    while (!isDone && peek() != '<' && peek() != '`' && peek() != '~') {
      advance();
    }
    return _input.substring(start, _index);
  }

  /// Attempts to scan a Markdown inline code span or fenced code block
  /// starting at the current position.
  ///
  /// Returns a [TokenType.markdown] token on success, or `null` if the
  /// current position does not begin a valid Markdown code region (in which
  /// case the scanner position is restored to where it was before the call).
  Token? scanMarkdown() {
    final start = _index;
    final fenceChar = peek();

    if (fenceChar != '`' && fenceChar != '~') return null;

    // Count consecutive opening characters
    final openStart = _index;
    while (!isDone && peek() == fenceChar) {
      advance();
    }
    final openCount = _index - openStart;

    // Tildes: fewer than 3 do not start a code region — backtrack
    if (fenceChar == '~') {
      if (openCount < 3) {
        _index = start;
        return null;
      }
      return _scanFencedBlock(start, fenceChar, openCount);
    }

    // Backticks: 3 or more start a fenced code block
    if (openCount >= 3) {
      return _scanFencedBlock(start, fenceChar, openCount);
    }

    // Backticks 1–2: inline code span
    // Search for a closing run of exactly the same count
    while (!isDone) {
      if (peek() != '`') {
        advance();
        continue;
      }
      final closeStart = _index;
      while (!isDone && peek() == '`') {
        advance();
      }
      final closeCount = _index - closeStart;
      if (closeCount == openCount) {
        return Token(TokenType.markdown, _input.substring(start, _index));
      }
      // Count mismatch — keep scanning
    }

    // No closing delimiter found — backtrack and treat as plain text
    _index = start;
    return null;
  }

  Token _scanFencedBlock(int start, String fenceChar, int openCount) {
    // Skip optional language identifier and the opening line's newline
    while (!isDone && peek() != '\n') {
      advance();
    }
    if (!isDone) advance(); // consume '\n'

    // Search for a closing fence: a line that begins with >= openCount
    // of the same fence character
    while (!isDone) {
      final lineStart = _index;
      while (!isDone && peek() == fenceChar) {
        advance();
      }
      final closeCount = _index - lineStart;
      if (closeCount >= openCount) {
        // Consume the rest of the closing line
        while (!isDone && peek() != '\n') {
          advance();
        }
        if (!isDone) advance(); // consume '\n'
        return Token(TokenType.markdown, _input.substring(start, _index));
      }
      // Not a closing fence — advance to the end of this line
      while (!isDone && peek() != '\n') {
        advance();
      }
      if (!isDone) advance(); // consume '\n'
    }

    // Unclosed fenced block — protect everything to end of input
    return Token(TokenType.markdown, _input.substring(start));
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

  static bool _isTagStartChar(int c) =>
      (c >= 0x41 && c <= 0x5A) || // A-Z
      (c >= 0x61 && c <= 0x7A) || // a-z
      c == 0x21 ||
      c == 0x3F; // ! ?

  static bool _isTagNameChar(int c) =>
      (c >= 0x41 && c <= 0x5A) || // A-Z
      (c >= 0x61 && c <= 0x7A) || // a-z
      (c >= 0x30 && c <= 0x39) || // 0-9
      c == 0x21 ||
      c == 0x3F; // ! ?

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
