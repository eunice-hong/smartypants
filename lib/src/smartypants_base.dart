class SmartyPants {
  static String formatText(String input) {
    // Replace straight quotes with smart quotes
    String output = input.replaceAllMapped(
      RegExp(r'"([^"]+)"'),
      (match) => '“${match[1]}”',
    );

    // Replace triple hyphens with em dash
    output = output.replaceAll('---', '—');

    // Replace double hyphens with en dash
    output = output.replaceAll('--', '–');

    // Replace straight apostrophes with smart apostrophes
    output = output.replaceAll("'", '’');

    // Replace multiple spaces with a single space
    output = output.replaceAll(RegExp(r'\s+'), ' ');

    // Replace ellipsis
    output = output.replaceAll('...', '…');

    // Replace mathematical symbols
    output = output
        .replaceAll('>=', '≥')
        .replaceAll('<=', '≤')
        .replaceAll('!=', '≠');

    // Replace arrows
    output = output
        .replaceAll('<->', '↔')
        .replaceAll('->', '→')
        .replaceAll('<-', '←')
        .replaceAll('=>', '⇒');

    return output;
  }
}
