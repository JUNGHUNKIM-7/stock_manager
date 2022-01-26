import 'package:router_go/bloc/constant/base_controller.dart';

abstract class InventorySearchBlocInterface {
  void onChanged(String val);
}

mixin InventorySearchMixin<T extends String> {}

class InventorySearchBloc extends BaseStreamController<String>
    with InventorySearchMixin
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
