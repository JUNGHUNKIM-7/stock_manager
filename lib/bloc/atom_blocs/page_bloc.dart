import '../../bloc/constant/base_controller.dart';

abstract class PageBlocInterface {
  void switchPage(int onTapVal);
}

class PageBloc extends BaseStreamController<int>
    implements BaseInterface<int>, PageBlocInterface {
  PageBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<int> get stream => subject.stream;

  @override
  void switchPage(int onTapVal) {
    state = onTapVal;
  }
}
