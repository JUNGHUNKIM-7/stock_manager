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

  Blocs._();

  Blocs.initializer({required this.historyData, required this.inventoryData}) {
    historyData = historyData;
    inventoryData = inventoryData;
  }

  final historyView =
      HistoryViewBloc(state: [], type: HistoryViewBlocEnum.history);
  final inventoryView =
      HistoryViewBloc(state: [], type: HistoryViewBlocEnum.inventory);

  final chipBloc = ChipBloc(state: DateTime.now().month - 1);
  late final historyBloc =
      HistoryBloc(state: historyData, handler: GSheetHandler());
  final historySearchBloc = HistorySearchBloc(state: '');

  late final inventoryBloc =
      InventoryBloc(state: inventoryData, handler: GSheetHandler());
  final inventorySearchBloc = InventorySearchBloc(state: '');

  final yearSelection = YearSelectionBloc(state: DateTime.now().year);
  final inStatus = FilterButtonStatusBloc(state: true);
  final outStatus = FilterButtonStatusBloc(state: true);

  final titleField = ProductField(state: '');
  final memoField = MemoFieldBloc(state: '');
  final qtyField = QtyFieldBloc(state: '');

  final themeBloc = ThemeBloc(state: false);
  late final pageBloc = PageBloc(
      state: 0,
      historySearch: historySearchBloc,
      inventorySearch: inventorySearchBloc);
}
