import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:qr_sheet_stock_manager/screen/global_components/appbar_wrapper.dart';
import 'package:qr_sheet_stock_manager/styles.dart';

import 'markdown_util_func.dart';

class ManualMarkdown extends StatelessWidget {
  const ManualMarkdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(context: context, typeOfForm: 'manual'),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: MarkdownBody(
                styleSheet: markdownBase(context),
                onTapLink: linkUrl,
                data: """
# The Guide of Linking Sheet to App
### 
### 
### 
**ALL STEPS ARE ESSENTIAL FOR RUNNING THE APP**
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
* Need: { ALL Content } (Including curly brackets)
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
          """,
              ),
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
      ),
    );
  }
}
