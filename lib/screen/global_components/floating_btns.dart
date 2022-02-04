import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/global/theme_bloc.dart';
import '../../styles.dart';

class QrFloatingBtn extends StatelessWidget {
  const QrFloatingBtn({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: theme.stream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              tooltip: 'Make a Deal with QR',
              foregroundColor:
                  snapshot.data! ? Styles.darkColor : Styles.lightColor,
              backgroundColor:
                  snapshot.data! ? Styles.lightColor : Styles.darkColor,
              elevation: 10.0,
              child: const Icon(Icons.qr_code_scanner_rounded),
              onPressed: () => context.goNamed('qrCamera'),
            );
          }
          return Container();
        });
  }
}

class ExportToExcelBtn extends StatelessWidget {
  const ExportToExcelBtn({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: theme.stream,
        builder: (context, AsyncSnapshot<bool> themeSnapShot) {
          if (themeSnapShot.hasData) {
            return FloatingActionButton(
              tooltip: 'Export Data',
              foregroundColor:
                  themeSnapShot.data! ? Styles.darkColor : Styles.lightColor,
              backgroundColor:
                  themeSnapShot.data! ? Styles.lightColor : Styles.darkColor,
              elevation: 10.0,
              child: const Icon(Icons.outbond_outlined),
              onPressed: () {
                //make excel sheet, pass snapshotData
              },
            );
          }
          return Container();
        });
  }
}
