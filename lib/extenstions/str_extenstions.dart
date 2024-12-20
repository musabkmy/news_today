extension StringExtensions on String {
  String removeExtraSpaces() {
    return replaceAllMapped(RegExp(r'\s+'), (match) {
      int length = match.group(0)!.length;
      if (length < 2) {
        return ' ';
      } else {
        return '\n';
      }
    }).trim();
  }
}
