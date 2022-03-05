import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void linkUrl(text, href, title) {
  href != null ? launch(href) : null;
}

MarkdownStyleSheet markdownBase(BuildContext context) {
  return MarkdownStyleSheet(
    code: GoogleFonts.jetBrainsMono(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
    strong: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.redAccent,
    ),
    p: Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(fontSize: 16, letterSpacing: 0.4),
    codeblockDecoration: (BoxDecoration(
      color: Colors.redAccent,
    )),
    codeblockPadding: EdgeInsets.all(5),
    h1: Theme.of(context)
        .textTheme
        .headline3
        ?.copyWith(fontSize: 24, letterSpacing: 0.2),
    h1Align: WrapAlignment.center,
    h2: Theme.of(context)
        .textTheme
        .headline2
        ?.copyWith(fontSize: 20, letterSpacing: 0.2),
    h3: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
    h4: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16),
    a: Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontSize: 16, color: Colors.redAccent),
  );
}
