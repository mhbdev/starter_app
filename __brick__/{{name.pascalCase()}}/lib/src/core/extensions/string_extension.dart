import 'regex_extensions.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isNumeric => num.tryParse(this) != null;
}

extension LanguageArgumentExt on String {
  String replaceArgs(List<String?>? args) {
    String translated = this;
    translated = translated.replaceAllMapped(
        RegExp(r'\$\(\w+\)\$', caseSensitive: false), (match) {
      return match.founded
          .replaceAll('\$(', '')
          .replaceAll(')\$', '')
          .replaceArgs(args);
    });

    if (args == null) {
      return translated;
    } else {
      for (String? arg in args) {
        if (translated.contains("\$arg\$")) {
          translated = translated.replaceFirst("\$arg\$", arg!);
        }
      }
      return translated;
    }
  }

  Text toRichText(
    TextStyle style, {
    TextDirection? textDirection,
    TextAlign? align,
    bool boldNumbers = false,
    bool underlinedNumbers = false,
  }) {
    final words = split(' ');
    return Text.rich(
      TextSpan(
          text: '',
          style: style,
          children: words
              .map(
                (e) => TextSpan(
                    text: e,
                    style: style.copyWith(
                        fontWeight:
                            e.isNumeric && boldNumbers ? FontWeight.bold : null,
                        decoration: e.isNumeric && underlinedNumbers
                            ? TextDecoration.underline
                            : null),
                    children: [TextSpan(text: ' ', style: style)]),
              )
              .toList()),
      textAlign: align,
      textDirection: textDirection,
    );
  }
}
