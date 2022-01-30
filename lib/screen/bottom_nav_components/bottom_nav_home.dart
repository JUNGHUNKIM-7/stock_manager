import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/bloc/global/page_bloc.dart';
import 'package:router_go/styles.dart';
import 'bottom_nav_bar.dart';

import '../page_wrapper/fourth_page.dart';
import '../page_wrapper/first_page.dart';

import '../page_wrapper/second_page.dart';
import '../page_wrapper/third_page.dart';
import '../global_components/appbar_icons.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class TabNavHome extends StatelessWidget {
  const TabNavHome({Key? key}) : super(key: key);

  static final pages = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
    const FourthPage(),
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
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: snapshot.data == 1
                  ? StreamBuilder(
                      stream: theme.stream,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData) {
                          return FloatingActionButton(
                            foregroundColor: snapshot.data!
                                ? Styles.darkColor
                                : Styles.lightColor,
                            backgroundColor: snapshot.data!
                                ? Styles.lightColor
                                : Styles.darkColor,
                            elevation: 10.0,
                            child: const Icon(Icons.qr_code_scanner_sharp),
                            onPressed: () => context.goNamed('qrCamera'),
                          );
                        }
                        return Container();
                      })
                  : null,
              appBar: showAppBar(context, snapshot.data!),
              bottomNavigationBar: const BottomNavBar(),
              body: BodyStream(pageIdx: pageIdx, pages: pages),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class BodyStream extends StatelessWidget {
  const BodyStream({
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
