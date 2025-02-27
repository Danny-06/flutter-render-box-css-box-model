import 'dart:convert' show LineSplitter;


extension StringUtil on String {

  /// https://github.com/dart-lang/language/issues/559#issuecomment-527892329
  String trimIndent() {
    final lines = LineSplitter.split(this);

    String commonWhitespacePrefix(String stringA, String stringB) {
      var index = 0;

      for (; index < stringA.length && index < stringB.length; index++) {
        final codeUnitA = stringA.codeUnitAt(index);
        final codeUnitB = stringB.codeUnitAt(index);

        if (codeUnitA != codeUnitB) {
          break;
        }

        if (codeUnitA != 0x20 /* spc */ && codeUnitA != 0x09 /* tab */) {
          break;
        }
      }

      return stringA.substring(0, index);
    }

    final prefix = lines.reduce(commonWhitespacePrefix);
    final prefixLength = prefix.length;

    return lines.map((string) => string.substring(prefixLength)).join('\n');
  }

}
