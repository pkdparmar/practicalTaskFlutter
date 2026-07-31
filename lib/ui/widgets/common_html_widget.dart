import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:practicletestone/app/app_colour.dart';

class CommonHtmlWidget extends StatelessWidget {
  final String data;
  final double bodyFontSize;
  final Color bodyColor;
  final double lineHeight;
  final Map<String, Style>? extraStyles;

  const CommonHtmlWidget({
    super.key,
    required this.data,
    this.bodyFontSize = 14,
    this.bodyColor = AppColour.white70,
    this.lineHeight = 1.6,
    this.extraStyles,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyles = <String, Style>{
      'body': Style(
        color: bodyColor,
        fontSize: FontSize(bodyFontSize),
        fontFamily: 'Poppins',
        lineHeight: LineHeight(lineHeight),
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      'p': Style(
        color: bodyColor,
        margin: Margins.only(bottom: 8),
      ),
      'h1': Style(
        color: AppColour.white,
        fontSize: FontSize(bodyFontSize + 8),
        fontWeight: FontWeight.bold,
        margin: Margins.only(bottom: 8, top: 4),
      ),
      'h2': Style(
        color: AppColour.white,
        fontSize: FontSize(bodyFontSize + 6),
        fontWeight: FontWeight.bold,
        margin: Margins.only(bottom: 6, top: 4),
      ),
      'h3': Style(
        color: AppColour.white,
        fontSize: FontSize(bodyFontSize + 4),
        fontWeight: FontWeight.bold,
        margin: Margins.only(bottom: 6, top: 4),
      ),
      'strong': Style(
        color: AppColour.white,
        fontWeight: FontWeight.bold,
      ),
      'b': Style(
        color: AppColour.white,
        fontWeight: FontWeight.bold,
      ),
      'em': Style(
        color: bodyColor,
        fontStyle: FontStyle.italic,
      ),
      'ul': Style(
        color: bodyColor,
        margin: Margins.only(left: 16, bottom: 8),
      ),
      'ol': Style(
        color: bodyColor,
        margin: Margins.only(left: 16, bottom: 8),
      ),
      'li': Style(
        color: bodyColor,
        margin: Margins.only(bottom: 4),
      ),
      'a': Style(
        color: AppColour.primaryAccent,
        textDecoration: TextDecoration.none,
      ),
      'blockquote': Style(
        color: bodyColor,
        fontStyle: FontStyle.italic,
        border: const Border(
          left: BorderSide(color: AppColour.primaryAccent, width: 3),
        ),
        padding: HtmlPaddings.only(left: 12),
        margin: Margins.only(left: 0, bottom: 8),
      ),
      'code': Style(
        color: AppColour.primaryAccent,
        backgroundColor: AppColour.white.withValues(alpha: 0.05),
        fontFamily: 'monospace',
      ),
    };

    // Merge extra styles if provided
    final mergedStyles = {...defaultStyles, ...?extraStyles};

    return Html(
      data: data,
      style: mergedStyles,
    );
  }
}
