import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stock_manager/bloc/constant/base_controller.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/database/model/inventory_model.dart';

enum HistoryViewBlocEnum { history, inventory }

abstract class HistoryViewBlocInterface {
  void push(dynamic data);

  void clear(HistoryViewBlocEnum type);
}

class HistoryViewBloc extends BaseStreamController<List>
    implements BaseInterface<List>, HistoryViewBlocInterface {
  late final BehaviorSubject<List<History>> histories;
  late final BehaviorSubject<List<Inventory>> bookmarks;
  final Box? hiveHistoryBox;
  final Box? hiveBookMarkBox;

  HistoryViewBloc({
    required state,
    required HistoryViewBlocEnum type,
    this.hiveHistoryBox,
    this.hiveBookMarkBox,
  }) : super(state: state) {
    if (type == HistoryViewBlocEnum.history) {
      histories = BehaviorSubject<List<History>>.seeded(state);
    } else if (type == HistoryViewBlocEnum.inventory) {
      bookmarks = BehaviorSubject<List<Inventory>>.seeded(state);
    }
  }

  Stream<List<History>> get historyStream => histories.stream;

  Stream<List<Inventory>> get inventoryStream => bookmarks.stream;

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
  Future<void> push(dynamic data) async {
    if (data is History) {
      histories.add({...histories.value, data}.toList());
    } else if (data is Inventory) {}
  }

  @override
  void clear(HistoryViewBlocEnum type) {
    if (type == HistoryViewBlocEnum.history) {
      histories.add([]);
    } else if (type == HistoryViewBlocEnum.inventory) {}
  }
}
