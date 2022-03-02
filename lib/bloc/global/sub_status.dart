import '../constant/base_controller.dart';

abstract class SubStatusBlocInterface {
  void getStatus(bool val);
}

class SubStatusBloc extends BaseStreamController<bool>
    implements BaseInterface<bool>, SubStatusBlocInterface {
  SubStatusBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<bool> get stream => subject.stream;

  @override
  void getStatus(bool val) {
    state = val;
  }
}
