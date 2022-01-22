import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../../navigation.dart';
import '../../styles.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'database/repository/gsheet_handler.dart';
import 'database/repository/gsheet_repo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GSheetHandler.init();

  runApp(
    BlocProvider<BlocsCombiner>(
      child: App(router: PageRouter.router),
      combiner: BlocsCombiner(fetchedData: await GSheetRepository.getDataMap()),
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
