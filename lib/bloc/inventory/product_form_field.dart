import 'package:router_go/bloc/constant/base_controller.dart';
import 'dart:async';

abstract class ProductFieldInterface {
  void getValue(String? value);

  void clear();
}

mixin ProductFieldMixin<T extends String> {
  final validText = StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
        if (value.isEmpty) {
          sink.addError('This Field is Required');
        } else {
          sink.add(value.trim());
        }
      });
}

class ProductField extends BaseStreamController<String>
    with ProductFieldMixin
    implements BaseInterface<String>, ProductFieldInterface {
  ProductField({required state}) : super(state: state);

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
