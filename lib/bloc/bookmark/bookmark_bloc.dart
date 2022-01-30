import 'package:router_go/bloc/constant/base_controller.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';

abstract class BookMarkBlocInterface {
  void reload();

  void push(Inventory inventory);
}

mixin BookMarkMixin<T extends List<Inventory>> {}

class BookMarkBloc extends BaseStreamController<List<Inventory>>
    with BookMarkMixin
    implements BaseInterface<List<Inventory>>, BookMarkBlocInterface {
  BookMarkBloc({required state, required this.handler}) : super(state: state);

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
        await handler.fetchData(SheetType.bookmark) as List<Inventory>;
    state = newState;
  }

  @override
  Future<void> push(Inventory inventory) async {
    await handler
        .insertOne(
          type: SheetType.bookmark,
          bookmark: Inventory.toMap(inventory),
        )
        .whenComplete(() => handler.fetchData(SheetType.bookmark).then((data) {
              state = data as List<Inventory>;
            }));
  }
}
