import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_sheet_stock_manager/database/hive_utils/box_handler.dart';
import 'package:qr_sheet_stock_manager/database/model/history_model.dart';
import 'package:qr_sheet_stock_manager/database/model/inventory_model.dart';
import 'package:qr_sheet_stock_manager/fall_back.dart';

import '../../navigation.dart';
import '../../styles.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'database/repository/gsheet_handler.dart';
import 'database/repository/gsheet_repository.dart';

Future<void> runApplication() async {
  final boxHandler = await SettingBoxHandler.returnBox();
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    if (boxHandler['secret'] != null && boxHandler['sheetId'] != null) {
      if (boxHandler['secret'].isNotEmpty && boxHandler['sheetId'].isNotEmpty) {
        await runAppWithNetwork(boxHandler);
      }
    } else {
      runFallback(boxHandler, App(router: PageRouter.router));
    }
  } else {
    runFallback(boxHandler, NoConnectionApp());
  }
}

Future<void> runAppWithNetwork(Map<String, dynamic> boxHandler) async {
  await SheetHandlerMain.init(sheetId: boxHandler['sheetId']);
  final fetchedData = await GSheetRepository.getDataMap();

  runApp(
    BlocProvider<BlocsCombiner>(
      child: App(router: PageRouter.router),
      combiner: BlocsCombiner(
        handlerMap: boxHandler['handler'],
        historyData: fetchedData['history']!.cast<History>(),
        inventoryData: fetchedData['inventory']!.cast<Inventory>(),
      ),
    ),
  );
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
