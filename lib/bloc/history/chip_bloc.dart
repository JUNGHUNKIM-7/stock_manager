import 'package:router_go/bloc/constant/base_controller.dart';

abstract class ChipInterface {
  void setIdx(int selectedVal);
}

class ChipBloc extends BaseStreamController<int>
    implements BaseInterface<int>, ChipInterface {
  ChipBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<int> get stream => subject.stream;

  @override
  void setIdx(int selectedVal) {
    state = selectedVal;
  }
}
