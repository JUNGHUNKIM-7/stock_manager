import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';

import '../page_wrapper/fourth_page.dart';
import '../page_wrapper/first_page.dart';
import '../page_wrapper/second_page.dart';
import '../page_wrapper/third_page.dart';
import '../global_components/appbar_icons.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

//todo drawer설치
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

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: const [
              Text('test'),
              Text('test'),
              Text('test'),
              Text('test'),
              Text('test'),
              Text('test'),
              Text('test'),
            ],
          ),
        ),
        appBar: showAppBar(context),
        bottomNavigationBar: const BottomNavBar(),
        body: StreamBuilder(
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
        ),
      ),
    );
  }
}
