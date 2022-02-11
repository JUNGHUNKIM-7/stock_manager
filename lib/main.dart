import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:router_go/database/hive_storage/box_handler.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/secret/secret.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../navigation.dart';
import '../../styles.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'database/hive_storage/histories.dart';
import 'database/hive_storage/hive_handler.dart';
import 'database/hive_storage/settings.dart';
import 'database/repository/gsheet_handler.dart';
import 'database/repository/gsheet_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Future.wait(
      [Hive.initFlutter(), HiveHandler.init(), SecretHandler.initialize()]);
  HiveHandler.registerAdapter([SettingsAdapter(), HistoriesAdapter()]);
  await HiveHandler.openRegisteredBox(['settings', 'histories']);
  final handler = await BoxHandler.returnBox();

  if (handler['secret'] != null && handler['sheetId'] != null) {
    if (handler['secret'].isNotEmpty && handler['sheetId'].isNotEmpty) {
      await GSheetHandler.init(sheetId: handler['sheetId']);
      final fetchedData = await GSheetRepository.getDataMap();

      runApp(
        BlocProvider<BlocsCombiner>(
          child: App(router: PageRouter.router),
          combiner: BlocsCombiner(
            handlerMap: handler['handler'],
            historyData: fetchedData['history']!.cast<History>(),
            inventoryData: fetchedData['inventory']!.cast<Inventory>(),
          ),
        ),
      );
    }
  } else {
    //서비스 등록 페이지
    //todo secret 잘못 입력했을때 탈출?
    //todo 서비스 등록페이지?
    runApp(
      BlocProvider<BlocsCombiner>(
        child: App(router: PageRouter.router),
        combiner: BlocsCombiner(handlerMap: handler['handler'] ?? {}),
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
          title: 'Stock Manager',
        ),
      ),
    );
  }
}
