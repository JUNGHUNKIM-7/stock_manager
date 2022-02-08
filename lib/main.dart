import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../navigation.dart';
import '../../styles.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'database/hive_storage/histories.dart';
import 'database/hive_storage/settings.dart';
import 'database/hive_storage/hive_handler.dart';
import 'database/repository/gsheet_handler.dart';
import 'database/repository/gsheet_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Future.wait([
    Hive.initFlutter(),
    HiveHandler.init(['settings']),
  ]);
  HiveHandler.registerAdapter([SettingsAdapter(), HistoriesAdapter()]);
  await GSheetHandler.init();
  final fetchedData = await GSheetRepository.getDataMap();

  runApp(
    BlocProvider<BlocsCombiner>(
      child: App(router: PageRouter.router),
      combiner: BlocsCombiner(
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
          title: 'Stock Manager',
        ),
      ),
    );
  }
}
