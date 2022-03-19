import 'package:inventory_tracker/bloc/constant/base_controller.dart';
import 'package:inventory_tracker/database/model/inventory_model.dart';
import 'package:inventory_tracker/database/utils/gsheet_handler.dart';

abstract class InventoryBlocInterface {
  void reload();

  void delete(String id);

  Inventory filterByIdWithQr(String scanData);
}

class InventoryBloc extends BaseStreamController<List<Inventory>>
    implements BaseInterface<List<Inventory>>, InventoryBlocInterface {
  InventoryBloc({required state, required this.handler}) : super(state: state);

  final SheetHandlerMain handler;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<List<Inventory>> get stream => subject.stream;

  @override
  Future<void> reload() async {
    final newState = await handler.fetchData(SheetType.inventory);
    state = newState.cast<Inventory>();
  }

  @override
  Future<void> delete(String id) async {
    await handler
        .deleteOne(id, SheetType.inventory)
        .whenComplete(() => reload());
  }

  @override
  Inventory filterByIdWithQr(String? scanData) {
    return state.firstWhere((element) => element.id == scanData);
  }
}
