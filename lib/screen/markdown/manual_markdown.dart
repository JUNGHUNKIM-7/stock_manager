import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inventory_tracker/bloc/constant/blocs_combiner.dart';
import 'package:inventory_tracker/bloc/constant/provider.dart';
import 'package:inventory_tracker/screen/global_components/appbar_wrapper.dart';
import 'package:inventory_tracker/styles.dart';

import 'markdown_util_func.dart';

class ManualMarkdown extends HookWidget {
  const ManualMarkdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;
    final themeStream = useStream(theme.stream);

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(context: context, typeOfForm: 'manual'),
        body: ListView(
          children: [
            SizedBox(height: outerSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: MarkdownBody(
                styleSheet: markdownBase(context, themeStream),
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
##
- Example :
- MUST INCLUDE CURLY BRACKETS

```
{"type" : ... "client_x509_cert_url": ...}
```
* Apply Credentials to app

###
###

## 3. Set Google Sheet ID
* Make a GoogleSheet in your Google Drive, then, you can find the ID in the Sheet URL.
* Example :
```
docs.google.com/spreadsheets/d/ "YOUR SHEET ID" /edit#gid=...
```
* Apply your sheet ID to app

###
###

## 4. Share Document
* Share your "Google Service Account" in your sheet
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
            ),
            SizedBox(height: outerSpacing),
          ],
        ),
      ),
    );
  }
}
