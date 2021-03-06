import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_tracker/database/model/history_model.dart';
import 'package:inventory_tracker/database/model/inventory_model.dart';
import 'package:inventory_tracker/utils/restart_widget.dart';

import '../../navigation.dart';
import '../../styles.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'bloc/global/sub_status.dart';
import 'database/in_app_purchase/purchase_api.dart';
import 'database/utils/get_box.dart';
import 'database/utils/gsheet_handler.dart';
import 'database/utils/gsheet_repository.dart';

class RunApp {
  static Future<void> runApplication([SubStatusBloc? subStatusBloc]) async {
    final boxHandler = await returnBox();
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (boxHandler['secret'] != null && boxHandler['sheetId'] != null) {
        if (boxHandler['secret'].isNotEmpty &&
            boxHandler['sheetId'].isNotEmpty) {
          await runAppWithNetwork(
            boxHandler,
            subStatusBloc ?? purchaseApi.getSubStatusBloc,
          );
        }
      } else {
        runFallback(boxHandler, App(router: getRouter()));
      }
    } else {
      runFallback(boxHandler, NoConnectionApp());
    }
  }

  static Future<void> runAppWithNetwork(
    Map<String, dynamic> boxHandler,
    SubStatusBloc subStatusBloc,
  ) async {
    await SheetHandlerMain.init(sheetId: boxHandler['sheetId']);
    final initialMap = await getDataMap();

    runApp(
      BlocProvider<BlocsCombiner>(
        child: App(router: getRouter()),
        combiner: BlocsCombiner(
          handlerMap: boxHandler['handler'],
          historyData: initialMap['history']!.cast<History>(),
          inventoryData: initialMap['inventory']!.cast<Inventory>(),
          subStatusBloc: subStatusBloc,
        ),
      ),
    );
  }

  static void runFallback(Map<String, dynamic> boxHandler, Widget child) async {
    runApp(
      RestartWidget(
        child: BlocProvider<BlocsCombiner>(
          child: child,
          combiner: BlocsCombiner(handlerMap: boxHandler['handler'] ?? {}),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key, required this.router}) : super(key: key);

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: StreamBuilder(
        stream: theme.stream,
        builder: (_, AsyncSnapshot<bool> snapshot) => MaterialApp.router(
          theme: Styles(darkMode: snapshot.data ?? theme.state).themeMain(),
          debugShowCheckedModeBanner: false,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          title: 'Qr Sheet Stock Manager',
        ),
      ),
    );
  }
}

class NoConnectionApp extends StatelessWidget {
  const NoConnectionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Styles.lightColor,
          body: NoConnectionPage(),
        ),
      ),
    );
  }
}

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 50, color: Styles.darkColor),
            SizedBox(height: outerSpacing),
            Text(
              'No Internet Connection'.toUpperCase(),
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 26),
            ),
            SizedBox(height: outerSpacing / 2),
            Text(
              'Please check your network connection. then Restart the App',
              style:
                  Theme.of(context).textTheme.headline4?.copyWith(fontSize: 14),
            ),
            SizedBox(height: outerSpacing),
            OutlinedButton(
              onPressed: () async {
                RestartWidget.restartApp(context);
                await RunApp.runApplication();
              },
              child: Text(
                'Restart App',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
