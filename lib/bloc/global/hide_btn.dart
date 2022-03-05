import '../constant/base_controller.dart';

abstract class HideButtonBlocInterface {
  void changeVal();
}

mixin HideButtonMixin<T extends bool> {}

class HideButtonBloc extends BaseStreamController<bool>
    with HideButtonMixin
    implements BaseInterface<bool>, HideButtonBlocInterface {
  HideButtonBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<bool> get stream => subject.stream;

  @override
  void changeVal() {
    state = !state;
  }
}
