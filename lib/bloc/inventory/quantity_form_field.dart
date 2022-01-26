import 'package:router_go/bloc/constant/base_controller.dart';
import 'dart:async';

abstract class QtyBlocInterface {
  void getValue(String? value);

  void clear();
}

mixin QtyFieldMixin<T extends String> {
  final validText = StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      sink.addError('Only number is allowed');
    } else if (value.isEmpty) {
      sink.addError('This Field is required');
    } else {
      sink.add(value.trim());
    }
  });
}

class QtyFieldBloc extends BaseStreamController<String>
    with QtyFieldMixin
    implements BaseInterface<String>, QtyBlocInterface {
  QtyFieldBloc({required state}) : super(state: state);

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
