import 'package:router_go/bloc/constant/base_controller.dart';
import 'dart:async';

abstract class MemoFieldInterface {
  void clear();

  void getValue(String? value);
}

class MemoFieldBloc extends BaseStreamController<String?>
    implements BaseInterface<String?>, MemoFieldInterface {
  MemoFieldBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<String?> get stream => subject.stream;

  @override
  void getValue(String? value) {
    if (value != null) {
      state = value;
    }
  }

  @override
  void clear() {
    state = '';
  }
}
