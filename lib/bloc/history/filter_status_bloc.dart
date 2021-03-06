import 'package:inventory_tracker/bloc/constant/base_controller.dart';

abstract class FilterButtonStatusInterface {
  void switchVal();
}

class FilterButtonStatusBloc extends BaseStreamController<bool>
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
  Stream<bool> get stream => subject.stream;
}
