import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class BottomNavBar extends HookWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageIdx = BlocProvider.of<BlocsCombiner>(context).pageBloc;
    final pageStream = useStream(pageIdx.stream);

    return BottomNavigationBar(
      showUnselectedLabels: false,
      iconSize: 25,
      onTap: pageIdx.switchPage,
      type: BottomNavigationBarType.fixed,
      currentIndex: pageStream.hasData ? pageStream.data! : 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.transform),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'Inventory',
        ),
      ],
    );
  }
}
