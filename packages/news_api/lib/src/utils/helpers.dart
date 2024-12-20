// ignore_for_file: avoid_print

import 'package:news_api/news_api.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'package:sanitize_html/sanitize_html.dart';

//list of unwanted sources
const List<String> excludedSourcesIds = ['al-jazeera-english'];

String getSources(List<SourceEntity> sources) {
  String result = '';
  void addId(String? id) {
    if (id != null) {
      result += result == '' ? id : ',$id';
    }
  }

  if (sources.isNotEmpty) {
    for (int i = 0; (i < sources.length && i <= 15); i++) {
      print('i was: $i');
      addId(sources[i].id);
    }
  }
  return result;
}

///check for a url to be matched to news open api content link and return the url and the remaining chars to be retrieved
///ex: "In the week before the documentary was released, online betting markets had Len Sassaman,
///a cryptographer who moved in similar online circles to Satoshi, as the most likely candidate to
///be revealed a… [+1575 chars]"
(bool isValid, String? contentStart, int? remainingChars)
    extractContentStartAndRemainingChars(String contentInfo) {
  //divider between content start and remaining chars
  String marker = "… [+";

  // Find the index of the marker
  int markerIndex = contentInfo.indexOf(marker);
  // Check if the marker exists in the input string
  if (markerIndex == -1) {
    return (false, null, null);
  }

  // Extract the text before the marker
  String extractedText = contentInfo.substring(0, markerIndex);
  // Extract the number of chars after the '+'
  int plusIndex = markerIndex + marker.length;
  if (plusIndex == -1) {
    return (false, null, null);
  }

  String remainingString = contentInfo.substring(plusIndex);
  // Find the index of the next space
  int spaceIndex = remainingString.indexOf(" ");
  if (spaceIndex == -1) {
    return (false, null, null);
  }

  // Extract the number of characters
  String charCountStr = remainingString.substring(0, spaceIndex);
  int charCount;
  try {
    charCount = int.parse(charCountStr);
  } catch (e) {
    return (false, null, null);
  }
  return (true, extractedText, charCount);
}

String cleanParsedText(String parsedText) {
  // Remove extra whitespace, newlines, and tabs
  String cleanedText =
      html_parser.parse(parsedText).documentElement?.text ?? '';
  cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim();
  return cleanedText;
}

int getSearchLimit(int length) {
  if (length < 15) {
    return length;
  }
  int mid = length ~/ 2;
  return mid < 15
      ? 15
      : mid > 25
          ? 25
          : mid;
}

Future<void> fetchAndExtractCleanContent(
    String url, String contentStart, int remainingChars) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 150) {
      final rawContent = response.body;
      // print('response: ${response.body.substring(0, 100)}');

      // Parse HTML and extract text
      Document document = html_parser.parse(rawContent);
      final parsedText = document.body?.text ?? '';
      final cleanedContent = sanitizeHtml(parsedText);
      // String cleanedContent = cleanParsedText(temp);

      // print('Extracted and cleaned content:');
      // print('Cleaned: ${cleanedContent.substring(1000, 1400)}');

      // Search for the start string in the entire body
      int startIndex = cleanedContent.indexOf(contentStart);
      if (startIndex != -1) {
        // Calculate the end index based on the provided length
        int endIndex = startIndex + contentStart.length + remainingChars;
        if (endIndex > cleanedContent.length) {
          endIndex = cleanedContent.length;
          print('endIndex out of bound.');
        }
        print('got it!!');
        print(cleanedContent.substring(startIndex, endIndex));
      } else {
        print('Start string not found in the content.');
      }
    } else {
      throw Exception('Failed to load article content');
    }
  } catch (e) {
    print('Error: $e');
  }
}
