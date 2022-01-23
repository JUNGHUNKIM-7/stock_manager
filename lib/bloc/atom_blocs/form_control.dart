import 'package:router_go/bloc/constant/base_controller.dart';
import 'dart:async';

abstract class FormControlBlocInterface {
  void getValue(String? value);

  void clear();
}

mixin FormControlMixin<T extends String> {
  final validText = StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
        if (value.isEmpty) {
          sink.addError('This Field is Required');
        } else {
          sink.add(value.trim());
        }
      });
}

class FormControlBloc extends BaseStreamController<String>
    with FormControlMixin
    implements BaseInterface<String>, FormControlBlocInterface {
  FormControlBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<String> get stream => subject.stream.transform(validText);

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
