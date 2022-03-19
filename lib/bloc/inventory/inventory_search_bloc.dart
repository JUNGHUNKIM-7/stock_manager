import 'package:inventory_tracker/bloc/constant/base_controller.dart';

abstract class InventorySearchBlocInterface {
  void onChanged(String val);
}

class InventorySearchBloc extends BaseStreamController<String>
    implements BaseInterface<String>, InventorySearchBlocInterface {
  InventorySearchBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<String> get stream => subject.stream;

  @override
  void onChanged(String val) {
    state = val;
  }
}
