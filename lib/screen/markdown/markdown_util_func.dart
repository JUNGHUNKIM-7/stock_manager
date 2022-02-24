import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void linkUrl(text, href, title) {
  href != null ? launch(href) : null;
}

MarkdownStyleSheet markdownBase(BuildContext context) {
  return MarkdownStyleSheet(
    textAlign: WrapAlignment.spaceBetween,
    code: GoogleFonts.jetBrainsMono(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    p: Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(fontSize: 16, color: Colors.black),
    codeblockDecoration: (BoxDecoration(
      color: Colors.red,
    )),
    codeblockPadding: EdgeInsets.all(5),
    h1: Theme.of(context).textTheme.headline3?.copyWith(fontSize: 24),
    h1Align: WrapAlignment.center,
    h2: Theme.of(context).textTheme.headline2?.copyWith(fontSize: 20),
    h3: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
    h4: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
    a: Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontSize: 16, color: Colors.red),
  );
}
