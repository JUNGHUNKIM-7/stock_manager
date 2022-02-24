import 'package:flutter/material.dart';
import 'package:qr_sheet_stock_manager/bloc/global/page_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../global_components/appbar_wrapper.dart';
import '../global_components/floating_btns.dart';
import '../global_components/settings_drawer.dart';
import '../page_wrapper/first_page.dart';
import '../page_wrapper/second_page.dart';
import 'bottom_nav_bar.dart';

class TabNavHome extends StatefulWidget {
  const TabNavHome({Key? key}) : super(key: key);

  static final pages = [
    const FirstPage(),
    const SecondPage(),
  ];

  @override
  State<TabNavHome> createState() => _TabNavHomeState();
}

class _TabNavHomeState extends State<TabNavHome> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    final pageIdx = BlocProvider.of<BlocsCombiner>(context).pageBloc;
    final theme = BlocProvider.of<BlocsCombiner>(context).themeBloc;

    return SafeArea(
      child: StreamBuilder(
        stream: pageIdx.stream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: _scaffoldKey,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: snapshot.data == 0
                  ? ExportToTemp()
                  : snapshot.data == 1
                      ? const QrCamera()
                      : null,
              appBar: showAppBar(context, snapshot.data!, theme),
              bottomNavigationBar: const BottomNavBar(),
              body: BodyPages(pageIdx: pageIdx, pages: TabNavHome.pages),
              drawer: SettingsDrawer(theme: theme),
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }
}

class BodyPages extends StatelessWidget {
  const BodyPages({
    Key? key,
    required this.pageIdx,
    required this.pages,
  }) : super(key: key);

  final PageBloc pageIdx;
  final List<Widget> pages;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: pageIdx.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return pages[snapshot.data ?? pageIdx.state];
        } else if (snapshot.error != null) {
          pageIdx.dispose();
          throw Exception('Page Transition');
        }
        return Container();
      },
    );
  }
}
