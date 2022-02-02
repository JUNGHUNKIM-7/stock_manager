import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:router_go/bloc/constant/base_controller.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

abstract class InventoryBlocInterface {
  void reload();

  void delete(String id);

  Inventory filterByIdWithQr(Barcode id);
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
    final newState =
        await handler.fetchData(SheetType.inventory) as List<Inventory>;
    state = newState;
  }

  @override
  Future<void> delete(String id) async {
    await handler
        .deleteOne(id, SheetType.inventory)
        .whenComplete(() => reload());
  }

  // for Qr Scan
  @override
  Inventory filterByIdWithQr(Barcode id) {
    return state.firstWhere((element) => element.id == id.toString());
  }
}
