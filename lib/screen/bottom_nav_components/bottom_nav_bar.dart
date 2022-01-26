import 'package:flutter/material.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageIdx = BlocProvider.of<BlocsCombiner>(context).pageBloc;

    return StreamBuilder(
      stream: pageIdx.stream,
      builder: (context, snapshot) {
        return BottomNavigationBar(
          showUnselectedLabels: false,
          iconSize: 20.0,
          elevation: 0.0,
          onTap: pageIdx.switchPage,
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIdx.state,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.linked_camera),
              label: 'QR Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
          ],
        );
      },
    );
  }
}
