import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_sheet_stock_manager/bloc/constant/provider.dart';
import 'package:qr_sheet_stock_manager/bloc/global/theme_bloc.dart';
import 'package:qr_sheet_stock_manager/styles.dart';
import 'package:qr_sheet_stock_manager/utils/move_file.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/utils/gsheet_handler.dart';

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
                      fontSize: 26,
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

class Settings extends StatelessWidget {
  const Settings({Key? key, required this.theme}) : super(key: key);
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

class UserInventory extends StatelessWidget {
  const UserInventory({Key? key, required this.theme, required this.handler})
      : super(key: key);
  final ThemeBloc theme;
  final SheetHandlerMain handler;

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;
    final historyBloc = BlocProvider.of<BlocsCombiner>(context).historyBloc;
    final isPro = BlocProvider.of<BlocsCombiner>(context).isPro;

    return StreamBuilder<bool>(
        stream: isPro.stream,
        builder: (context, snapshot) {
          return snapshot.data ?? false
              ? IconButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.yellow[600],
                        content: Text(
                          'Pending: Processing Your Request',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 14),
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
                            'Error: Can\'t extract your inventory from "inventory" sheet, Check your "inventory" sheet and try again',
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
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
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
                )
              : Container();
        });
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
    final isPro = BlocProvider.of<BlocsCombiner>(context).isPro;
    return StreamBuilder<bool>(
        stream: isPro.stream,
        builder: (context, snapshot) {
          return snapshot.data ?? false
              ? IconButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.yellow[600],
                        content: Text(
                          'Pending: Processing Your Request',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 14),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    try {
                      final dummyData = await handler.extractIdForQr();
                      final data =
                          await rootBundle.load("assets/CascadiaMonoPL.ttf");
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
                                          final title =
                                              titleList[i][idx] as String;
                                          final memo =
                                              memoList[i][idx] as String;
                                          return pw.Column(
                                            children: [
                                              pw.Container(child: qr),
                                              pw.Text(
                                                  title.length > 10
                                                      ? '${title.substring(0, 5)}..${title.substring(title.length - 5)}'
                                                      : title,
                                                  style: myStyle),
                                              pw.Text(
                                                  memo.length > 10
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

                          await _writingPDF(doc);

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[600],
                          content: Text(
                            'Failed to export QrCode list. Check your network connection and "inventory sheet" are not empty',
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
                        return Icon(
                          Icons.subdirectory_arrow_right,
                          size: 25,
                          color: snapshot.data ?? false
                              ? Styles.lightColor
                              : Styles.darkColor,
                        );
                      }),
                )
              : Container();
        });
  }

  Future<void> _writingPDF(pw.Document doc) async {
    final output = Hive.box('settings').get('storagePath');
    final file =
        File('${output}/qr_code-${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await doc.save());
    await moveFile(file,
        '/storage/emulated/0/Download/qr_code-${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
}
