import 'package:router_go/bloc/constant/base_controller.dart';

abstract class FilterButtonStatusInterface {
  void switchVal();

  void printStatus(int where);
}

mixin FilterButtonStatusMixin<T extends bool> {}

class FilterButtonStatusBloc extends BaseStreamController<bool>
    with FilterButtonStatusMixin
    implements BaseInterface<bool>, FilterButtonStatusInterface {
  FilterButtonStatusBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  void switchVal() {
    state = !state;
  }

  @override
  void printStatus(int where) {
    print('$where $state');
  }

  @override
  Stream<bool> get stream => subject.stream;
}
