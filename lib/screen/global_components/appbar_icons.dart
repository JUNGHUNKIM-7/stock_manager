import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stock_manager/bloc/constant/provider.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/theme_bloc.dart';
import 'package:stock_manager/styles.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';
import 'dark_mode_toggle.dart';
import 'history_panel.dart';

AppBar showAppBar(BuildContext context, int pageIdx, ThemeBloc theme) {
  final handler = GSheetHandler();

  switch (pageIdx) {
    case 0:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) => AppBarSettingsBtn(theme: theme)),
        actions: [
          const HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.history,
          ),
          const SizedBox(
            width: 4.0,
          )
        ],
        title: MainHeader(
          title: 'History',
          theme: theme,
        ),
      );
    case 1:
      return AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => AppBarSettingsBtn(theme: theme),
        ),
        actions: [
          PdfMaker(
            theme: theme,
            handler: handler,
          ),
          UserInventoryBtn(
            theme: theme,
            handler: handler,
          ),
          const HistoryPanel(
            historyViewBlocEnum: HistoryViewBlocEnum.inventory,
          ),
          const SizedBox(
            width: 4.0,
          )
        ],
        title: MainHeader(
          title: 'Inventory',
          theme: theme,
        ),
      );
    default:
      return AppBar(
          automaticallyImplyLeading: false,
          leading:
              Builder(builder: (context) => AppBarSettingsBtn(theme: theme)),
          actions: [
            DarkModeToggle(
              iconSize: 25.0,
              theme: theme,
            ),
            const SizedBox(
              width: 4.0,
            )
          ],
          title: MainHeader(title: 'Stocks', theme: theme));
  }
}

class PdfMaker extends StatelessWidget {
  const PdfMaker({
    Key? key,
    required this.handler,
    required this.theme,
  }) : super(key: key);
  final GSheetHandler handler;
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
          final data = await rootBundle.load("assets/open_sans.ttf");
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
                        textStyle: myStyle,
                        data: e,
                        barcode: pw.Barcode.qrCode(),
                        width: 100,
                        height: 100),
                  )
                  .toList();

              final qrList = chunk(convertToQr!, 24);
              final titleList = chunk(dummyData['title']!, 24);

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
                              return pw.Column(
                                children: [
                                  pw.Container(child: qr),
                                  pw.Text(
                                      title.length > 10
                                          ? '${title.substring(0, 5)}..${title.substring(title.length - 5)}'
                                          : title,
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

              final output = await getTemporaryDirectory();
              final file = File(
                  '${output.path}/qr_code-${DateTime.now().millisecondsSinceEpoch}.pdf');

              await file.writeAsBytes(await doc.save());

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
                'Failed to Export Qr Code : Fetching Data Error',
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
              Icons.qr_code_scanner_rounded,
              color:
                  snapshot.data ?? false ? Styles.lightColor : Styles.darkColor,
            );
          }),
    );
  }
}

class UserInventoryBtn extends StatelessWidget {
  const UserInventoryBtn({Key? key, required this.theme, required this.handler})
      : super(key: key);
  final ThemeBloc theme;
  final GSheetHandler handler;

  @override
  Widget build(BuildContext context) {
    final inventoryBloc = BlocProvider.of<BlocsCombiner>(context).inventoryBloc;

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
          await handler.moveToInventoryAndBackUp();
          await inventoryBloc.reload();
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
                  Icons.playlist_add,
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

AppBar showAppBarWithBackBtn({
  required BuildContext context,
  String? typeOfForm,
  BlocsCombiner? combiner,
}) =>
    AppBar(
      actions: [
        IconButton(
          onPressed: () {
            if (typeOfForm != null) {
              if (typeOfForm == 'history') {
                combiner?.statusFieldBloc.clearHistoryForm(FormFields.status);
                combiner?.valFieldBloc.clearHistoryForm(FormFields.val);
              }
              if (typeOfForm == 'inventory') {
                combiner?.titleFieldBloc.clearInventoryForm(FormFields.title);
                combiner?.memoFieldBloc.clearInventoryForm(FormFields.memo);
                combiner?.qtyFieldBloc.clearInventoryForm(FormFields.qty);
              }
              if (typeOfForm == 'historyDetails') {
                combiner?.historySearchBloc.onChanged('');
              }
              if (typeOfForm == 'inventoryDetails') {
                combiner?.inventorySearchBloc.onChanged('');
              }
            }
            context.goNamed('home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(
          width: 4.0,
        ),
      ],
      title: typeOfForm == 'history'
          ? Text(
              'History    Form'.toUpperCase(),
              style:
                  Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18),
            )
          : typeOfForm == 'inventory'
              ? Text(
                  'Inventory    Form'.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 18),
                )
              : typeOfForm == 'historyDetails'
                  ? Text(
                      'History   Details'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 18),
                    )
                  : Text(
                      'Inventory   Details'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 18),
                    ),
    );
