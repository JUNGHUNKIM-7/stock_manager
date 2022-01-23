import 'package:router_go/bloc/atom_blocs/history_search_bloc.dart';
import 'package:router_go/bloc/atom_blocs/inventory_search_bloc.dart';

import '../../bloc/constant/base_controller.dart';

abstract class PageBlocInterface {
  void switchPage(int onTapVal);
}

class PageBloc extends BaseStreamController<int>
    implements BaseInterface<int>, PageBlocInterface {
  PageBloc({required state,
    required this.inventorySearch,
    required this.historySearch})
      : super(state: state);

  final InventorySearchBloc inventorySearch;
  final HistorySearchBloc historySearch;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<int> get stream => subject.stream;

  @override
  void switchPage(int onTapVal) {
    state = onTapVal;
    if (onTapVal == 0) {
      inventorySearch.onChanged('');
    }
    else if (onTapVal == 1) {
      historySearch.onChanged('');
    }
  }
}
