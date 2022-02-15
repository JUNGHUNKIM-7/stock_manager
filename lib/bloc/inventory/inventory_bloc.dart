import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stock_manager/bloc/constant/base_controller.dart';
import 'package:stock_manager/database/model/inventory_model.dart';
import 'package:stock_manager/database/repository/gsheet_handler.dart';

abstract class InventoryBlocInterface {
  void reload();

  void delete(String id);

  Inventory filterByIdWithQr(String scanData);
}

class InventoryBloc extends BaseStreamController<List<Inventory>>
    implements BaseInterface<List<Inventory>>, InventoryBlocInterface {
  InventoryBloc({required state, required this.handler}) : super(state: state);

  final GSheetHandler handler;

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

  // for Qr Scan
  @override
  Inventory filterByIdWithQr(String? scanData) {
    return state.firstWhere((element) => element.id == scanData);
  }
}
