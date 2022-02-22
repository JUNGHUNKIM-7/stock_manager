import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/styles.dart';
import 'package:stock_manager/utils/move_file.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({Key? key, required this.title, required this.theme})
      : super(key: key);
  final String title;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: theme.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Text(
                title,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontSize: 20,
                      color: snapshot.data! == true
                          ? Styles.lightColor
                          : Styles.darkColor,
                    ),
              );
            }
          }
          return Container();
        });
  }
}

class AppBarSettingsBtn extends StatelessWidget {
  const AppBarSettingsBtn({Key? key, required this.theme}) : super(key: key);
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Icon(
                  Icons.settings,
                  size: 25,
                  color: snapshot.data! == true
                      ? Styles.lightColor
                      : Styles.darkColor,
                );
              }
            }
            return Container();
          }),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}

class UserInventoryBtn extends StatelessWidget {
  const UserInventoryBtn({Key? key, required this.theme, required this.handler})
      : super(key: key);
  final ThemeBloc theme;
  final SheetHandlerMain handler;

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;
    final historyBloc = BlocProvider.of<BlocsCombiner>(context).historyBloc;

    return IconButton(
      onPressed: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.yellow[600],
            content: Text(
              'Pending: Processing Your Request',
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 14),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
        try {
          await handler
              .updateInventoryAndHistoryWithBackup()
              .whenComplete(() => Future.wait([
                    historyBloc.reload(),
                    inventoryBloc.reload(),
                  ]));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[600],
              content: Text(
                'Success: All Items are Added to "inventory" Sheet',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontSize: 14),
              ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[600],
              content: Text(
                'Failed: ${e.toString().split(':')[1]}',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontSize: 14),
              ),
            ),
          );
        }
      },
      icon: StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Icon(
                  Icons.add,
                  size: 25,
                  color: snapshot.data! == true
                      ? Styles.lightColor
                      : Styles.darkColor,
                );
              }
            }
            return Container();
          }),
    );
  }
}

class PdfMaker extends StatelessWidget {
  const PdfMaker({
    Key? key,
    required this.handler,
    required this.theme,
  }) : super(key: key);
  final SheetHandlerMain handler;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.yellow[600],
            content: Text(
              'Pending: Processing Your Request',
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 14),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
        try {
          final dummyData = await handler.extractIdForQr();
          final data = await rootBundle.load("assets/CascadiaMonoPL.ttf");
          final myFont = pw.Font.ttf(data);
          final myStyle = pw.TextStyle(font: myFont);

          List chunk(List list, int chunkSize) {
            List chunks = [];
            int len = list.length;
            for (var i = 0; i < len; i += chunkSize) {
              int size = i + chunkSize;
              chunks.add(list.sublist(i, size > len ? len : size));
            }
            return chunks;
          }

          if (dummyData != null) {
            if (dummyData['id'] != null &&
                dummyData['id']!.isNotEmpty &&
                dummyData['title'] != null &&
                dummyData['title']!.isNotEmpty) {
              final doc = pw.Document();

              final convertToQr = dummyData['id']
                  ?.map(
                    (e) => pw.BarcodeWidget(
                        data: e,
                        barcode: pw.Barcode.qrCode(),
                        width: 100,
                        height: 100),
                  )
                  .toList();

              final qrList = chunk(convertToQr!, 24);
              final titleList = chunk(dummyData['title']!, 24);
              final memoList = chunk(dummyData['memo']!, 24);

              final len = (convertToQr.length / 24).ceil();
              for (var i = 0; i < len; ++i) {
                doc.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Wrap(
                          spacing: 20,
                          children: List.generate(
                            qrList[i].length,
                            (int idx) {
                              final qr = qrList[i][idx];
                              final title = titleList[i][idx] as String;
                              final memo = memoList[i][idx] as String;
                              return pw.Column(
                                children: [
                                  pw.Container(child: qr),
                                  pw.Text(
                                      title.length > 5
                                          ? '${title.substring(0, 5)}..${title.substring(title.length - 5)}'
                                          : title,
                                      style: myStyle),
                                  pw.Text(
                                      memo.length > 5
                                          ? '${memo.substring(0, 5)}..${memo.substring(memo.length - 5)}'
                                          : memo,
                                      style: myStyle),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ); // Page
              }

              final output = Hive.box('settings').get('storagePath');
              final file = File(
                  '${output}/qr_code-${DateTime.now().millisecondsSinceEpoch}.pdf');
              await file.writeAsBytes(await doc.save());
              await moveFile(file,
                  '/storage/emulated/0/Download/qr_code-${DateTime.now().millisecondsSinceEpoch}.pdf');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[600],
                  content: Text(
                    'Success: All your Qr are Exported as PDF',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontSize: 14),
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[600],
                  content: Text(
                    'Error: "inventory" Sheet Seems to be Empty',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontSize: 14),
                  ),
                ),
              );
            }
          }
        } catch (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.red[600],
          //     content: Text(
          //       'Failed to Export Qr Code : Fetching Data Error',
          //       style: Theme.of(context)
          //           .textTheme
          //           .headline4
          //           ?.copyWith(fontSize: 14),
          //     ),
          //   ),
          // );
          print(e);
        }
      },
      icon: StreamBuilder<bool>(
          stream: theme.stream,
          builder: (context, snapshot) {
            return Icon(
              Icons.subdirectory_arrow_right,
              size: 25,
              color:
                  snapshot.data ?? false ? Styles.lightColor : Styles.darkColor,
            );
          }),
    );
  }
}
