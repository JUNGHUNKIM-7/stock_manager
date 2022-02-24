import 'dart:async';

import 'package:qr_sheet_stock_manager/bloc/constant/base_controller.dart';
import 'package:rxdart/rxdart.dart';

enum FormFields { title, memo, qty, status, val }

abstract class FormBlocInterface {
  void clearHistoryForm(FormFields fields);

  void clearInventoryForm(FormFields fields);

  void getValue(String? value, FormFields type);

  get titleStream;

  get memoStream;

  get qtyStream;

  get outStream;

  get valStream;
}

class FormBloc extends BaseStreamController<String>
    with FormMixin
    implements BaseInterface<String>, FormBlocInterface {
  BehaviorSubject<String>? title;
  BehaviorSubject<String>? memo;
  BehaviorSubject<String>? qty;
  BehaviorSubject<String>? status;
  BehaviorSubject<String>? val;

  FormBloc({String? state, required FormFields fields})
      : super(state: state ?? '') {
    switch (fields) {
      case FormFields.title:
        title ??= BehaviorSubject<String>.seeded(state ?? '');
        break;
      case FormFields.memo:
        memo ??= BehaviorSubject<String>.seeded(state ?? '');
        break;
      case FormFields.qty:
        qty ??= BehaviorSubject<String>.seeded(state ?? '');
        break;
      case FormFields.status:
        status ??= BehaviorSubject<String>.seeded(state ?? '');
        break;
      case FormFields.val:
        val ??= BehaviorSubject<String>.seeded(state ?? '');
        break;
      default:
        throw Exception('Invalid Type');
    }
  }

  @override
  void dispose() {
    subject.close();
    title?.close();
    memo?.close();
    qty?.close();
    status?.close();
    val?.close();
  }

  @override
  Stream<String> get stream => throw UnimplementedError();

  @override
  Stream<String>? get titleStream => title?.stream.transform(makeRequired);

  @override
  Stream<String?>? get memoStream => memo?.stream;

  @override
  Stream<String>? get qtyStream => qty?.stream.transform(requiredAndValidInt);

  @override
  Stream<String>? get outStream => status?.stream;

  @override
  Stream<String>? get valStream => val?.stream.transform(requiredAndValidInt);

  @override
  void getValue(String? value, FormFields fields, [bool? isOut = false]) {
    switch (fields) {
      case FormFields.title:
        title?.add(value ?? '');
        break;
      case FormFields.memo:
        memo?.add(value ?? '');
        break;
      case FormFields.qty:
        qty?.add(value ?? '');
        break;
      case FormFields.status:
        status?.add(value ?? '');
        break;
      case FormFields.val:
        val?.add(value ?? '');
        break;
      default:
        throw Exception('Invalid Type');
    }
  }

  @override
  void clearInventoryForm(FormFields fields) {
    switch (fields) {
      case FormFields.title:
        title?.add('');
        break;
      case FormFields.memo:
        memo?.add('');
        break;
      case FormFields.qty:
        qty?.add('');
        break;
      default:
    }
  }

  @override
  void clearHistoryForm(FormFields fields) {
    switch (fields) {
      case FormFields.status:
        status?.add('y');
        break;
      case FormFields.val:
        val?.add('');
        break;
      default:
    }
  }
}

mixin FormMixin<T extends String> {
  final makeRequired = StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
    if (value.isEmpty) {
      sink.addError('This Field is Required');
    } else {
      sink.add(value.trim());
    }
  });
  final requiredAndValidInt = StreamTransformer<String, String>.fromHandlers(
      handleData: (String value, EventSink<String> sink) {
    if (value.contains(RegExp(r'[^\w\s]+'))) {
      sink.addError('Any Character is not Allowed');
    } else if (value.isEmpty) {
      sink.addError('This Field is Required');
    } else if (int.parse(value).isNegative) {
      sink.addError('Only Positive Number is Allowed');
    } else {
      sink.add(value.trim());
    }
  });
}
