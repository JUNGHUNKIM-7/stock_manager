import 'package:qr_sheet_stock_manager/bloc/constant/base_controller.dart';
import 'package:qr_sheet_stock_manager/database/model/history_model.dart';
import 'package:qr_sheet_stock_manager/database/utils/gsheet_handler.dart';

abstract class HistoryBlocInterface {
  void reload();
}

class HistoryBloc extends BaseStreamController<List<History>>
    implements BaseInterface<List<History>>, HistoryBlocInterface {
  HistoryBloc({required state, required this.handler}) : super(state: state);

  final SheetHandlerMain handler;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<List<History>> get stream => subject.stream;

  @override
  Future<void> reload() async {
    final newState = await handler.fetchData(SheetType.history);
    state = newState.cast<History>();
  }
}
