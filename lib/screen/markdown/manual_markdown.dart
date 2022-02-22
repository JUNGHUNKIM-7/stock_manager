import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_manager/screen/global_components/appbar_wrapper.dart';
import 'package:stock_manager/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkDownManual extends StatelessWidget {
  const MarkDownManual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarWithBackBtn(context: context, typeOfForm: 'manual'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
            child: MarkdownBody(
                styleSheet: MarkdownStyleSheet(
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
                  h1: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 24),
                  h1Align: WrapAlignment.center,
                  h2: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(fontSize: 20),
                  h3: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18),
                  h4: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 16),
                  a: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 16, color: Colors.red),
                ),
                onTapLink: (text, href, title) {
                  href != null ? launch(href) : null;
                },
                data: """
# The Guide of Linking Sheet to App
### 
### 
### 

## 1. Set your Timezone 
* Default: "America/New_York"
* That is essential for getting correct time

### 
### 

## 2. Set Google Sheet Credentials
* Open your desktop for settings.
* All the Credentials are stored in the ".json" file, You must download and keep it.
-- [How to get Credentials? (Link)](https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430)
* Go json viewer, Find "Open" tap above, then, Click "Open from disk" and copy the content of the file 
-- [Online json file viewer (Link)](https://jsoneditoronline.org/)
* Need: { ALL Content include curly bracket }
* Apply Credentials to app

### 
### 

## 3. Set Google Sheet ID
* Make a Google sheet and Find sheet ID
```
docs.google.com/spreadsheets/d/ "YOUR SHEET ID" /edit#gid=...
```
* Apply your sheet ID to app

### 
### 

## 4. Share Document
* Add your google service account to your sheet you made
        """),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: outerSpacing, vertical: innerSpacing),
            child: Image(
              image: AssetImage('assets/manual/share.png'),
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
