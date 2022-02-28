import 'package:flutter/material.dart';

import 'app.dart';
import 'bloc/constant/blocs_combiner.dart';
import 'bloc/constant/provider.dart';
import 'styles.dart';
import 'utils/restart_widget.dart';

void runFallback(Map<String, dynamic> boxHandler, Widget child) async {
  runApp(
    RestartWidget(
      child: BlocProvider<BlocsCombiner>(
        child: child,
        combiner: BlocsCombiner(handlerMap: boxHandler['handler'] ?? {}),
      ),
    ),
  );
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
                await runApplication();
              },
              child: Text('Restart App',
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
