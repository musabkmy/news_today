extension StringExtensions on String? {
  // Returns an empty string if the value is null
  String get valueOrEmpty {
    if (this == 'null') return '';
    return this ?? '';
  }

  // Returns true if the string is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  String extractBaseUrl() {
    if (this!.startsWith('https://') || this!.startsWith('http://')) {
      int endIndex = this!.indexOf('/', 8); // Start searching after "https://"
      // If there is no '/', return the entire this
      if (endIndex == -1) {
        return this!;
      }
      // Return the substring from the start to the first '/'
      return this!.substring(0, endIndex);
    }
    // If the this doesn't start with "https://", return it as is
    return '';
  }
}
