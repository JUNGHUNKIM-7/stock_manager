import 'package:hive/hive.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/bloc/global/history_view.dart';
import 'package:stock_manager/bloc/global/settings_bloc.dart';

import '../../bloc/global/page_bloc.dart';
import '../../bloc/global/theme_bloc.dart';
import '../../bloc/history/chip_bloc.dart';
import '../../bloc/history/filter_status_bloc.dart';
import '../../bloc/history/history_bloc.dart';
import '../../bloc/history/history_search_bloc.dart';
import '../../bloc/history/year_selection_bloc.dart';
import '../../bloc/inventory/inventory_bloc.dart';
import '../../bloc/inventory/inventory_search_bloc.dart';
import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import '../../database/repository/gsheet_handler.dart';

class Blocs {
  late List<History> historyData;
  late List<Inventory> inventoryData;
  late Box settingBox;
  late Map<String, dynamic> handlerMap;

  Blocs._();

  Blocs.initializer({
    required this.historyData,
    required this.inventoryData,
    required this.settingBox,
    required this.handlerMap,
  }) {
    settingBox = settingBox;
    handlerMap = handlerMap;
    historyData = historyData;
    inventoryData = inventoryData;
  }

  late final themeBloc = ThemeBloc(
      state: settingBox.get('darkMode') ?? false, settingBox: settingBox);
  late final pageBloc = PageBloc(
    state: 0,
    historySearch: historySearchBloc,
    inventorySearch: inventorySearchBloc,
  );

  final historyView = HistoryViewBloc(
    state: [].cast<History>(),
    type: HistoryViewBlocEnum.history,
  );

  late final settings = SettingsBloc(
    state: {
      'secret': settingBox.get('secret') ?? '',
      'sheetId': settingBox.get('sheetId') ?? '',
      'tz': settingBox.get('tz') ?? 'America/New_York',
    },
    settingBox: settingBox,
    handlerMap: handlerMap,
  );

  late final historyBloc =
      HistoryBloc(state: historyData, handler: GSheetHandler());
  late final inventoryBloc =
      InventoryBloc(state: inventoryData, handler: GSheetHandler());

  final historySearchBloc = HistorySearchBloc(state: '');
  final inventorySearchBloc = InventorySearchBloc(state: '');

  final chipBloc = ChipBloc(state: DateTime.now().month - 1);
  final yearSelection = YearSelectionBloc(state: DateTime.now().year);
  final inStatus = FilterButtonStatusBloc(state: true);
  final outStatus = FilterButtonStatusBloc(state: true);
  final descendingStatus = FilterButtonStatusBloc(state: true);

  final titleFieldBloc = FormBloc(fields: FormFields.title);
  final memoFieldBloc = FormBloc(fields: FormFields.memo);
  final qtyFieldBloc = FormBloc(fields: FormFields.qty);
  final statusFieldBloc = FormBloc(state: 'y', fields: FormFields.status);
  final valFieldBloc = FormBloc(fields: FormFields.val);
}
