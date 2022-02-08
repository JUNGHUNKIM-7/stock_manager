import 'dart:async';

import 'package:router_go/bloc/constant/base_controller.dart';
import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:rxdart/rxdart.dart';

enum HistoryViewBlocEnum { history, inventory }

abstract class HistoryViewBlocInterface {
  void push(dynamic data);

  void clear(HistoryViewBlocEnum type);
}

class HistoryViewBloc extends BaseStreamController<List>
    implements BaseInterface<List>, HistoryViewBlocInterface {
  late final BehaviorSubject<List> history;
  late final BehaviorSubject<List> inventory;

  HistoryViewBloc({required state, required HistoryViewBlocEnum type})
      : super(state: state) {
    if (type == HistoryViewBlocEnum.history) {
      history = BehaviorSubject<List>.seeded(state);
    } else if (type == HistoryViewBlocEnum.inventory) {
      inventory = BehaviorSubject<List>.seeded(state);
    }
  }

  Stream<List> get historyStream => history.stream;

  Stream<List> get inventoryStream => inventory.stream;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<List> get stream {
    return CombineLatestStream.combine2(
        historyStream, inventoryStream, (List a, List b) => [...a, ...b]);
  }

  @override
  void push(dynamic data) {
    if (data is History) {
      history.add({...history.value, data}.toList());
    } else if (data is Inventory) {
      inventory.add({...inventory.value, data}.toList());
    }
  }

  @override
  void clear(HistoryViewBlocEnum type) {
    if (type == HistoryViewBlocEnum.history) {
      history.add([]);
    } else if (type == HistoryViewBlocEnum.inventory) {
      inventory.add([]);
    }
  }
}
