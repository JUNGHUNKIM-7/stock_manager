import '../constant/base_controller.dart';

abstract class ThemeBlocInterface {
  void darkMode();
}

class ThemeBloc extends BaseStreamController<bool>
    implements BaseInterface<bool>, ThemeBlocInterface {
  ThemeBloc({required state}) : super(state: state);

  @override
  void darkMode() {
    subject.add(!subject.value);
  }

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<bool> get stream => subject.stream;
}
