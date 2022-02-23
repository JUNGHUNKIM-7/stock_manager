import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stock_manager/screen/global_components/appbar_wrapper.dart';
import 'package:stock_manager/styles.dart';

import 'markdown_util_func.dart';

class FeaturesMarkdown extends StatelessWidget {
  const FeaturesMarkdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(context: context, typeOfForm: 'Features'),
        body: ListView(
          children: [
            BodyForFeatures(data: """
# History Screen
### 
            """),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/filters.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: innerSpacing,
            ),
            BodyForFeatures(
              data: """
## 1. Filtering Data
### 
### 1-1. You can filter history by searching, month tabs & years tabs and in & out buttons
### 1-2. When you applied filters, your history will react to the filters directly
              """,
            ),
            SizedBox(
              height: innerSpacing,
            ),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/features1.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: innerSpacing,
            ),
            BodyForFeatures(data: """
### 1-3. You can export current filtered history as sheet via docked button
            """),
            ParagraphDivider(),
            BodyForFeatures(data: """
# Inventory Screen
### 
            """),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/features2.png'),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: innerSpacing,
            ),
            BodyForFeatures(data: """
## 1. Add & Delete
### 
### 1-1. Add a product individually via Add button
### 1-2. Add products via user typing in "user_inventory" sheet (useful for bulk adding to "inventory" sheet)
#### 1-2-1. fill your "user_inventory" sheet first, secondly press "+ button on top of app"
### 1-3. Your bookmarks will be shown in the right side of the inventory Screen
### 1-4. You can toggle bookmarks by clicking on the star icon in inventory Screen
            """),
            SizedBox(
              height: innerSpacing,
            ),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/dragging.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: innerSpacing,
            ),
            BodyForFeatures(data: """
### 1-5. Each tiles can be draggable
#### (Right to Left : Delete item from "Inventory" sheet, Left to Right : add a deal to "History" sheet)
            """),
            SizedBox(
              height: innerSpacing,
            ),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/qrscanner.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: innerSpacing,
            ),
            BodyForFeatures(data: """
## 2. Qr Scanner
### 2-1. You can find Qr code in both the inventory details and PDF file
### 2-2. This button will make PDF file which contains your Qr Codes based on your current inventory to your cellphone storage.
            """),
            SizedBox(
              height: innerSpacing,
            ),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/bulk.png'),
                fit: BoxFit.contain,
              ),
            ),
            ParagraphDivider(),
            BodyForFeatures(data: """
# Extra Features
### 
            """),
            BodyForFeatures(data: """
## 1. Automatically wrap up your history monthly & yearly 
### 1-1. Your history sheet will be split into previous month(year) & current month(year)
### 1-2. for example, file will be split into "2019-12" & "history"(current month)
            """),
            SizedBox(
              height: innerSpacing * 2,
            ),
            BodyForFeatures(data: """
## 2. Dark Mode 
### 2-1. Set theme on your preference
### 2-2. You can find this on settings button
            """),
            SizedBox(
              height: innerSpacing,
            ),
            ImageBorder(
              child: Image(
                image: AssetImage('assets/manual/darkmode.png'),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageBorder extends StatelessWidget {
  const ImageBorder({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          )),
    );
  }
}

class ParagraphDivider extends StatelessWidget {
  const ParagraphDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: outerSpacing),
      child: Divider(
        color: Colors.grey[700],
        thickness: 1.0,
      ),
    );
  }
}

class BodyForFeatures extends StatelessWidget {
  const BodyForFeatures({
    Key? key,
    required this.data,
  }) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
      child: MarkdownBody(
        styleSheet: markdownBase(context).copyWith(
          h1Align: WrapAlignment.start,
          h4: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14),
          h3: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
        ),
        onTapLink: linkUrl,
        data: data,
      ),
    );
  }
}
