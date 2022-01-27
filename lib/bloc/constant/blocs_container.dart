import 'package:router_go/bloc/bookmark/bookmark_bloc.dart';

import '../../bloc/global/history_view.dart';
import '../../bloc/global/page_bloc.dart';
import '../../bloc/global/theme_bloc.dart';
import '../../bloc/history/chip_bloc.dart';
import '../../bloc/history/filter_status_bloc.dart';
import '../../bloc/history/history_data_bloc.dart';
import '../../bloc/history/history_search_bloc.dart';
import '../../bloc/history/year_selection_bloc.dart';
import '../../bloc/inventory/product_form_field.dart';
import '../../bloc/inventory/inventory_bloc.dart';
import '../../bloc/inventory/inventory_search_bloc.dart';
import '../../bloc/inventory/memo_form_field.dart';
import '../../bloc/inventory/quantity_form_field.dart';
import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import '../../database/repository/gsheet_handler.dart';

class Blocs {
  late List<History> historyData;
  late List<Inventory> inventoryData;
  late List<Inventory> bookMarkData;

  Blocs.initializer(
      {required this.historyData,
      required this.inventoryData,
      required this.bookMarkData}) {
    historyData = historyData;
    inventoryData = inventoryData;
    bookMarkData = bookMarkData;
  }

  final themeBloc = ThemeBloc(state: false);
  late final pageBloc = PageBloc(
      state: 0,
      historySearch: historySearchBloc,
      inventorySearch: inventorySearchBloc);

  final historyView =
      HistoryViewBloc(state: [], type: HistoryViewBlocEnum.history);
  final inventoryView =
      HistoryViewBloc(state: [], type: HistoryViewBlocEnum.inventory);

  late final historyBloc =
      HistoryBloc(state: historyData, handler: GSheetHandler());
  late final inventoryBloc =
      InventoryBloc(state: inventoryData, handler: GSheetHandler());
  late final bookMarks =
      BookMarkBloc(state: bookMarkData, handler: GSheetHandler());

  final historySearchBloc = HistorySearchBloc(state: '');
  final inventorySearchBloc = InventorySearchBloc(state: '');

  final chipBloc = ChipBloc(state: DateTime.now().month - 1);
  final yearSelection = YearSelectionBloc(state: DateTime.now().year);
  final inStatus = FilterButtonStatusBloc(state: true);
  final outStatus = FilterButtonStatusBloc(state: true);

  final titleField = ProductField(state: '');
  final memoField = MemoFieldBloc(state: '');
  final qtyField = QtyFieldBloc(state: '');
}
