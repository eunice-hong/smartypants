import 'package:smartypants/smartypants.dart';

void main() {
  runBenchmark('Small input', _smallInput, iterations: 1000);
  runBenchmark('Large input', _largeInput, iterations: 1000);
  runBenchmark(
    'CJK-heavy',
    _cjkInput,
    iterations: 1000,
    config: SmartyPantsConfig(locale: SmartyPantsLocale.zhHant),
  );
  runBenchmark('HTML-heavy', _htmlInput, iterations: 1000);
  runBenchmark('Markdown-light', _markdownLightInput, iterations: 1000);
  runBenchmark('Markdown-heavy', _markdownHeavyInput, iterations: 1000);
}

void runBenchmark(
  String name,
  String input, {
  int iterations = 1000,
  SmartyPantsConfig? config,
}) {
  // warm up
  for (var i = 0; i < 10; i++) {
    SmartyPants.formatText(input, config: config);
  }

  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    SmartyPants.formatText(input, config: config);
  }
  stopwatch.stop();

  final totalMs = stopwatch.elapsedMilliseconds;
  final avgUs = stopwatch.elapsedMicroseconds / iterations;
  print(
    '[$name] ${iterations}x: ${totalMs}ms total, '
    '${avgUs.toStringAsFixed(1)}µs/call '
    '(input: ${input.length} chars)',
  );
}

// ---------------------------------------------------------------------------
// Benchmark inputs
// ---------------------------------------------------------------------------

const _smallInput = 'She said "Hello, world!" -- it\'s a great day... '
    'and the result is >= 10 or <= 5, so -> proceed!';

const _largeInput = '''
Chapter 1: "The Beginning"

It was the best of times---it was the worst of times. She said, "We need to
talk," and he replied, "I'm listening." The temperature was >= 30 degrees,
yet it felt <= 20. They walked -> the horizon and back <-> the shore.

Paragraph 2: Contractions and Dashes

It's amazing how we're able to adapt. They've seen it all before---the
highs and the lows. "Don't give up," he whispered. The margin was != 0,
which meant the formula was >= the threshold...

Paragraph 3: More Quotations

"Every great dream begins with a dreamer," she reminded him. "Always
remember, you have within you the strength, the patience, and the passion
to reach for the stars." He nodded -- it made sense.

Paragraph 4: Technical Notes

The algorithm runs in O(n log n) time. When x >= y and z <= w, the output
is != null. Use the arrow -> to indicate direction, or <-> for bidirectional
flow. The implication => holds when both sides are true...

Paragraph 5: Narrative

"Why do we fall?" asked the mentor. "So we can learn to pick ourselves up,"
answered the student. It's a lesson we've all heard---yet it's one we keep
needing to relearn. They've been at it for hours -- no sign of stopping...

Paragraph 6: More Contractions

We're not done yet. It's only the beginning. They've promised to return,
and we're holding them to it. "Don't worry," said the guide. "We'll make
it." The path ahead was != clear, but the direction was -> forward.

Paragraph 7: Ellipsis and Dashes

She paused... gathered her thoughts... and spoke. "This is it---our moment."
The crowd fell silent. Then -- slowly -- the applause began. "Is this really
happening?" she asked. "Yes," came the reply, "it's real..."

Paragraph 8: Numbers and Symbols

The value must be >= 100 and <= 200. Any reading != 150 triggers an alert.
The pointer moves -> right or <- left depending on input. Bidirectional:
<->. The implication => is strict here. Precision matters...

Paragraph 9: Dialogue Heavy

"Come in," said the host. "We've been expecting you." The visitor replied,
"I'm sorry I'm late." "Don't apologize---you're right on time," the host
insisted. "It's been a long road," the visitor admitted. "Indeed it has..."

Paragraph 10: Closing

And so they parted---each carrying a piece of the other's story. "We'll
meet again," she said. "I'm sure of it." He smiled. "It's not goodbye---
it's see you later." The door closed. The chapter ended... but the story?
The story was just beginning. >= all expectations, and <= any fear.

Paragraph 11: Repeated Themes

"Every ending is a new beginning," she wrote in her journal. It's a cliche,
but we've all felt its truth. They've documented it thoroughly---page after
page of observations. "Don't ignore the data," warned the analyst. The
trend was != random; it was -> deliberate...

Paragraph 12: Final Thoughts

In conclusion, we're reminded that it's not about where we've been, but
where we're going. "Keep moving," urged the coach. "We've got this." The
finish line was >= 10 kilometers away, but the spirit was <= daunted. One
step -> another. That's all it takes. And perhaps... that's enough.

Chapter 2: "The Middle Ground"

The second chapter opened with a question: "What's the point?" He wasn't
sure---nobody was. It's a feeling we've all had at some point. The numbers
didn't lie: >= 60% of respondents said they'd felt it too. The arrow of
time moves -> forward, never <-> back. That's just how it works...

Paragraph 14: Debate

"You're wrong," she said flatly. "I'm not---and here's why." He laid out
his argument point by point. It wasn't != the truth; it was just a different
angle. "Don't dismiss it," she warned. "We've been down that road before."
The margin of error was <= 2%, which meant the result was >= reliable.

Paragraph 15: The Long Road

They'd been walking for what felt like forever---hours turning into days.
"I can't go on," he said. "You can't not go on," she replied. It's a
paradox we've all faced. The distance was >= 50 miles, but the spirit was
<= exhausted. One step -> the next. That's the only formula that works...

Paragraph 16: Reflection

Looking back, it's clear that we've grown. "Don't underestimate progress,"
said the philosopher. "We've come further than we think." The arc of change
moves -> improvement, not <-> stagnation. The delta was != zero; it was
measurable, >= significant. She smiled. "I'm glad we didn't give up..."

Paragraph 17: The Argument

"It's not that simple," he insisted. "Yes it is---you're overthinking it,"
she shot back. They'd been at this for hours. The truth was somewhere >=
the obvious and <= the obscure. "Don't lose sight of what we're doing here,"
he urged. "We'll find it," she said. "We've always found it before..."

Paragraph 18: Night Thoughts

In the quiet of the night, she thought: "What's next?" The stars were !=
answers, but they were something. The telescope pointed -> a distant galaxy,
and she wondered <-> the vastness. "It's humbling," she wrote. "We're so
small---and yet we've built all this." The cosmos was >= indifferent, but
it was also <= hostile. Perhaps that was enough...

Paragraph 19: Morning

"Good morning," he said. "I'm ready." The day stretched -> possibility,
vast and != predictable. They'd packed what they needed---no more, no less.
"Don't overdo it," she reminded him. "We've got a long way to go." The
forecast was >= sunny with <= 20% chance of rain. A good day to move...

Paragraph 20: The Decision

It came down to this: "Do we go or do we stay?" He thought... she thought...
They'd been over it before---the pros, the cons. The expected value was >=
the risk. "I'm in," she said. "Me too," he agreed. And just like that, the
decision was made. Not with fanfare---just two words. -> Forward. That's all.

Paragraph 21: Aftermath

"I can't believe we did it," he said. "I can," she replied. "We've always
been capable of more than we thought." The results were != expected---they
were better. >= every projection, and <= any downside. "Don't let this go
to your head," warned the advisor. Too late---it already had. And that's
fine. It's earned. We'll take it.

Paragraph 22: Looking Forward

The road ahead was != clear, but it was -> visible. "We've done the hard
part," she said. "Haven't we?" He shrugged. "I'm not sure there is a hard
part---it's all hard." She laughed. "Fair point." They walked on. The sun
was >= warm and the breeze was <= cold. Perfect conditions for what comes
next. Whatever that is. Wherever that leads. Onward...

Paragraph 23: The Last Mile

"We're almost there," she said. The finish line was -> near, >= reachable,
<= a mile away. "Don't jinx it," he said. "I'm not---I'm just stating the
facts." It's a distinction we've all had to make at one point or another.
The data was != wrong. The trend was => positive. They'd made it. Almost.

Paragraph 24: The End of the Middle

And so the middle came to a close---not with a bang, not with a whisper,
but with a steady, deliberate step -> the next chapter. "I'm proud of us,"
she said. "We've earned this." He nodded. "It's been a long road." "It has."
They paused... looked back... and looked forward. Then walked on. >= hope,
<= doubt. That's the best any of us can do. And it's enough. It really is.
''';

const _cjkInput = '''
<<書籍>>의 세계에 오신 것을 환영합니다。。。이 책은 日本語와 中文를 함께 다룹니다。
<<文學>>은 인류의 유산입니다。。。我們一起來學習吧！<<知識>>是無價的。
日本の文化は豊かです。<<芸術>>の世界へようこそ。。。
한국어로도 읽을 수 있어요。<<언어>>는 소통의 도구입니다。。。
这本书介绍了<<历史>>的重要性。文化交流是美好的。。。

第一章：<<文化의 만남>>

동아시아의 문화는 오랜 역사를 가지고 있습니다。한국、중국、일본은 서로 깊은 영향을 주고받았습니다。
<<三國志>>는 중국의 역사를 담은 위대한 작품입니다。。。이를 통해 우리는 역사의 흐름을 이해할 수 있습니다。
日本では、<<源氏物語>>が世界最古の長編小説とされています。紫式部が書いたこの作品は、平安時代の宮廷生活を描いています。。。
중국의 <<紅樓夢>>은 청나라 시대의 걸작으로、가족의 흥망성쇠를 다루고 있습니다。
韓国の<<춘향전>>は、신분을 초월한 사랑 이야기로 오늘날에도 사랑받고 있습니다。。。

第二章：<<언어와 문자>>

한자(漢字)는 동아시아 문명의 공통 유산입니다。한국에서는 한글과 함께 사용되고、일본에서는 히라가나、가타카나와 함께 쓰입니다。
<<言語학>>의 관점에서 보면、이 세 언어는 서로 다른 어족에 속하지만 많은 한자어를 공유합니다。。。
中文的書寫系統有繁體字和簡體字兩種。<<文字改革>>是二十世紀中國的重大事件。
日本語には、平仮名、片仮名、漢字という三つの文字システムがあります。<<万葉集>>は最古の和歌集です。。。
한국의 세종대왕은 <<훈민정음>>을 창제하여 백성들이 쉽게 글을 읽고 쓸 수 있도록 하였습니다。

第三章：<<현대 사회와 전통>>

현대 사회에서도 전통 문화는 중요한 역할을 합니다。<<전통 예술>>은 현대적으로 재해석되어 새로운 생명을 얻고 있습니다。。。
中國的傳統節日如春節、中秋節，在現代社會依然深受重視。<<節日文化>>反映了民族的精神和價值觀。
日本の伝統芸能である<<歌舞伎>>や<<能楽>>は、ユネスコの無形文化遺産に登録されています。。。
한국의 <<판소리>>와 <<탈춤>>도 세계가 인정한 무형문화유산입니다。전통은 과거가 아닌 살아있는 현재입니다。

第四章：<<음식 문화>>

음식은 문화의 중요한 부분입니다。<<한식>>은 발효 음식으로 유명하며、특히 김치는 세계적으로 알려져 있습니다。。。
中國料理は世界で最も多様な料理の一つです。<<四川料理>>の辛さ、<<広東料理>>の繊細さ、地域によって全く異なります。
日本の<<和食>>は、2013年にユネスコの無形文化遺産に登録されました。一汁三菜という基本形式が特徴です。。。
세 나라 모두 쌀을 주식으로 하지만、조리 방법과 식문화는 매우 다릅니다。<<음식>>을 통해 문화를 이해할 수 있습니다。
''';

const _markdownLightInput = '''
# "Getting Started" with smartypants

Use `smart: true` to enable all transformations at once -- it's the simplest
option. For finer control, disable individual flags like `quotes: false`.

The arrow `->` represents direction; `<->` is bidirectional. Comparisons use
`>=` and `<=`, and `!=` means "not equal." These are left untouched inside
inline code spans.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  smartypants: ^0.0.4
```

Then run `dart pub get` -- you're ready to go.

## Basic Usage

```dart
final result = SmartyPants.formatText(
  '"Hello" -- it's a great day...',
);
// -> "\u201CHello\u201D \u2013 it\u2019s a great day\u2026"
```

Notice that `->` inside the code block is **not** transformed to \u2192.
The same applies to `!=`, `>=`, and `<=` operators -- they stay as-is.

## Configuration

```dart
final config = SmartyPantsConfig(
  quotes: true,   // "..." -> \u201C...\u201D
  dashes: true,   // -- -> \u2013, --- -> \u2014
  ellipsis: true, // ... -> \u2026
);
```

"Less is more," as they say... configure only what you need.
''';

const _markdownHeavyInput = '''
# smartypants -- A Typographic Transformation Library

> "Typography is the craft of endowing human language with a durable visual
> form." -- Robert Bringhurst

It's a Dart package that transforms plain ASCII punctuation into proper
typographic characters... without breaking your code.

---

## Why smartypants?

When you write `"Hello"` in plain text, you get straight quotes. But
*proper* typography calls for \u201Ccurly quotes\u201D -- a subtle difference
that makes text look more polished. The same applies to dashes (`--` ->
en-dash, `---` -> em-dash) and ellipsis (`...` -> \u2026).

The challenge is: how do you apply these transformations to prose **without**
corrupting code snippets? That's exactly what smartypants solves.

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  smartypants: ^0.0.4
```

```
dart pub get
```

---

## Core API

### `SmartyPants.formatText()`

```dart
import 'package:smartypants/smartypants.dart';

void main() {
  // Basic usage -- all transformations enabled by default
  final result = SmartyPants.formatText('"Hello, world!" -- it's great...');
  print(result); // \u201CHello, world!\u201D \u2013 it\u2019s great\u2026

  // Granular control -- disable specific transformations
  final config = SmartyPantsConfig(
    quotes: true,
    dashes: false,  // keep -- and --- as-is
    ellipsis: true,
    mathSymbols: false, // keep >=, <=, != as-is
    arrows: false,      // keep ->, <-, <-> as-is
  );
  final result2 = SmartyPants.formatText('"Hello" -- x >= 10', config: config);
}
```

### `SmartyPantsConfig`

All fields are `final` -- use `copyWith()` to create modified copies:

```dart
const base = SmartyPantsConfig(quotes: true, dashes: true);
final noEllipsis = base.copyWith(ellipsis: false);
```

The `smart` flag acts as a master switch. Setting `smart: false` disables
everything regardless of individual flags -- it's useful for opt-out scenarios.

---

## HTML Protection

Content inside HTML tags like `<code>`, `<pre>`, `<kbd>`, and `<math>` is
**never** transformed. For example:

```html
<p>She said "Hello" -- it's great.</p>
<pre>
  if (x >= 10 && y != null) {
    result -> next; // don't transform this!
  }
</pre>
```

The `<p>` content becomes \u201CShe said \u201CHello\u201D \u2013 it\u2019s
great.\u201D, while the `<pre>` block is left completely untouched.

---

## CJK Support

For East Asian text, smartypants handles additional transformations:

```dart
final config = SmartyPantsConfig(
  locale: SmartyPantsLocale.zhHant,
  cjkEllipsisNormalization: true,  // \u3002\u3002\u3002 -> \u2026
  cjkAngleBrackets: true,          // <<text>> -> \u300Atext\u300B
);
```

Use `<<書名>>` for book titles in Chinese -- it becomes \u300A\u66F8\u540D\u300B
automatically. The `!=` inside a code span like `a != b` stays unchanged.

---

## Inline Code Protection (Planned)

> **Note:** Inline code protection is planned for v0.1.0. Once implemented,
> backtick spans will be treated like `<code>` tags.

Currently, `` `a->b` `` is still transformed to `` `a\u2192b` `` -- this is
a known limitation. The fix involves extending the tokenizer in
`lib/src/tokenizer.dart` to recognize backtick-delimited spans.

Similarly, fenced code blocks like the ones throughout this document would be
protected:

```dart
// This entire block would be a protected region
// No transformations: -> != >= <= ... -- ---
final x = "untouched";
```

---

## Performance

The transformation pipeline runs in O(n) time relative to input length.
Here are representative benchmarks on a 2024 MacBook (Apple M3):

| Input type | Size    | Time/call |
|------------|---------|-----------|
| Small text | ~100 ch | ~5 \u03bcs    |
| Large text | ~5 KB   | ~50 \u03bcs   |
| CJK-heavy  | ~2 KB   | ~30 \u03bcs   |
| HTML-heavy | ~3 KB   | ~40 \u03bcs   |

Regex patterns are pre-compiled as `static final` fields -- they're not
recompiled on every call. That's the key to keeping per-call latency low
even for large inputs...

---

## Edge Cases

### Nested quotes

```
She said "He told me 'Don't worry' -- it's fine."
```

Becomes: She said \u201CHe told me \u2018Don\u2019t worry\u2019 \u2013 it\u2019s fine.\u201D

### Private-use-area characters

Internally, smartypants uses `U+FFFC` as an HTML placeholder and `U+E000`
as an escape character. If your input already contains these code points,
they're safely escaped before processing -- no data loss.

### The `!=` operator in prose

In prose, `x != y` becomes `x \u2260 y`. But inside any protected region
(HTML tag or, eventually, Markdown code span), it stays as `!=`. Context
matters -- and smartypants handles it correctly.

---

## Contributing

"The best way to improve a tool is to use it," someone once said... and then
file issues. See `CONTRIBUTING.md` for guidelines. PRs are welcome -- please
include tests for any new transformation rules. Coverage >= 80% is required.
''';

const _htmlInput = '''
<article>
  <h1>"Getting Started" Guide</h1>
  <p>She said "Hello, world!" -- it's a great way to begin. The result is
  <code>x >= 10</code> or <code>y <= 5</code>, so we proceed accordingly.</p>

  <h2>Section 1: "Core Concepts"</h2>
  <p>The arrow <strong>-></strong> shows direction, and <strong><-></strong>
  means bidirectional flow. Don't forget: <code>a != b</code> implies the
  values differ. The threshold is >= 100 and the limit is <= 500.</p>

  <pre>
    // Don't modify "this" code block
    if (x >= threshold && y <= limit) {
      result = x -> next;  // forward only
    }
    // a != b means they're different...
  </pre>

  <h2>Section 2: "Advanced Usage"</h2>
  <p>"Keep going," she said --- "we're almost there..." The implementation
  is straightforward once you've understood the basics. It's not as hard
  as it looks---trust the process.</p>

  <blockquote>
    <p>"Every tool has its purpose," wrote the engineer. "Don't use a hammer
    when you need a scalpel." The precision required was >= 0.001mm, while
    the tolerance was <= 0.005mm. That's the difference between success and
    failure...</p>
  </blockquote>

  <h2>Section 3: "Configuration"</h2>
  <p>The config file accepts values >= 0 and <= 1000. Any value != the
  default triggers a warning. Use the <code>-></code> operator to chain
  transformations, or <code><-></code> for reversible ones.</p>

  <ul>
    <li>Option A: "Fast mode" -- processes <= 100 items per second</li>
    <li>Option B: "Precise mode" -- accuracy >= 99.9%</li>
    <li>Option C: "Balanced mode" -- it's the best of both worlds...</li>
  </ul>

  <h2>Section 4: "Troubleshooting"</h2>
  <p>If you're seeing errors, don't panic. "It's probably a config issue,"
  said the support team. Check that your values are != null and that the
  path points -> the correct directory. The log file is usually located
  <code><-></code> the main config.</p>

  <pre>
    ERROR: "Connection refused" -- check your settings
    INFO:  threshold >= 10 required
    WARN:  value != expected (got <= 5, need >= 10)
  </pre>

  <p>We've seen this before---it's a known issue. Don't worry: it's fixable.
  The solution is -> straightforward once you've identified the root cause.
  "Take it step by step," advised the documentation. That's the key...</p>

  <h2>Section 5: "Best Practices"</h2>
  <p>"Always test your changes," urged the senior developer. "We've had too
  many incidents---let's not repeat them." The test coverage should be
  >= 80% and the build time <= 5 minutes. It's not just a suggestion---
  it's a requirement. Don't skip it.</p>

  <table>
    <thead>
      <tr>
        <th>"Metric"</th>
        <th>"Target"</th>
        <th>"Acceptable"</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Coverage</td>
        <td>>= 90%</td>
        <td>>= 80%</td>
      </tr>
      <tr>
        <td>Build time</td>
        <td><= 3 min</td>
        <td><= 5 min</td>
      </tr>
      <tr>
        <td>Response time</td>
        <td><= 100ms</td>
        <td><= 500ms</td>
      </tr>
    </tbody>
  </table>

  <h2>Section 6: "Conclusion"</h2>
  <p>In conclusion, it's been a great journey. We've covered a lot of
  ground---from basics to advanced topics. "I'm impressed," said the
  reviewer. "You've done it justice." The final score was >= expectations,
  and the effort was <= daunting in hindsight. One step -> the next.
  That's all it ever takes...</p>

  <footer>
    <p><em>"The best documentation is the one that doesn't need to exist,"
    -- someone wise once said. We've tried our best. It's not perfect---
    nothing is. But it's >= good enough to get you started.</em></p>
  </footer>
</article>
''';
