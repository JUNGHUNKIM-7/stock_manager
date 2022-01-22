import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

import '../../bloc/constant/base_controller.dart';

abstract class HistoryBlocInterface {
  void reload();
}

mixin HistoryMixin<T extends List<History>> {}

class HistoryBloc extends BaseStreamController<List<History>>
    with HistoryMixin
    implements BaseInterface<List<History>>, HistoryBlocInterface {
  HistoryBloc({required state, required this.handler}) : super(state: state);

  final GSheetHandler handler;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<List<History>> get stream => subject.stream;

  @override
  Future<void> reload() async {
    final newState =
        await handler.fetchData(SheetType.history) as List<History>;
    state = newState;
  }
}
