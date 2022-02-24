import 'package:qr_sheet_stock_manager/bloc/constant/base_controller.dart';
import 'package:qr_sheet_stock_manager/bloc/history/history_search_bloc.dart';
import 'package:qr_sheet_stock_manager/bloc/inventory/inventory_search_bloc.dart';

abstract class PageBlocInterface {
  void switchPage(int onTapVal);
}

class PageBloc extends BaseStreamController<int>
    implements BaseInterface<int>, PageBlocInterface {
  PageBloc({
    required state,
    required this.inventorySearch,
    required this.historySearch,
  }) : super(state: state);

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
    } else if (onTapVal == 1) {
      historySearch.onChanged('');
    }
  }
}
