import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/screen/global_components/appbar_icons.dart';

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({
    Key? key,
    required this.history,
  }) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBarWithBackBtn(context),
      body: Center(
        child: Column(
          children: [
            Text(history.title),
            ElevatedButton(
              onPressed: () {
                context.goNamed('home');
              },
              child: const Text('home'),
            )
          ],
        ),
      ),
    );
  }
}
