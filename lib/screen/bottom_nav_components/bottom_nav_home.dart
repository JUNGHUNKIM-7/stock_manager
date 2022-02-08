import 'package:flutter/material.dart';
import 'package:router_go/bloc/global/page_bloc.dart';
import '../global_components/floating_btns.dart';
import '../global_components/settings_drawer.dart';
import 'bottom_nav_bar.dart';

import '../page_wrapper/first_page.dart';
import '../page_wrapper/second_page.dart';
import '../global_components/appbar_icons.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class TabNavHome extends StatelessWidget {
  const TabNavHome({Key? key}) : super(key: key);

  static final pages = [
    const FirstPage(),
    const SecondPage(),
    // const ThirdPage(),
    // const FourthPage(),
  ];

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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: snapshot.data == 0
                  ? ExportToExcelBtn(theme: theme)
                  : snapshot.data == 1
                      ? QrFloatingBtn(theme: theme)
                      : null,
              appBar: showAppBar(context, snapshot.data!),
              bottomNavigationBar: const BottomNavBar(),
              body: BodyPages(pageIdx: pageIdx, pages: pages),
              drawer: SettingsDrawer(theme: theme),
            );
          }
          return Container();
        },
      ),
    );
  }
}


class BodyPages extends StatelessWidget {
  const BodyPages({
    Key? key,
    required this.pageIdx,
    required this.pages,
  }) : super(key: key);

  final PageBloc pageIdx;
  final List<StatelessWidget> pages;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: pageIdx.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return pages[snapshot.data ?? pageIdx.state];
        } else if (snapshot.error != null) {
          pageIdx.dispose();
          throw Exception('ERR: Page Transition');
        }
        return Container();
      },
    );
  }
}
