import 'dart:async';

import 'package:router_go/bloc/constant/base_controller.dart';

abstract class HistorySearchBlocInterface {
  void onChanged(String val);
}

class HistorySearchBloc extends BaseStreamController<String>
    implements BaseInterface<String>, HistorySearchBlocInterface {
  HistorySearchBloc({required state}) : super(state: state);

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
