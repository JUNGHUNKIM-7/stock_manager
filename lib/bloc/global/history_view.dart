import 'dart:async';

import 'package:hive/hive.dart';
import 'package:inventory_tracker/bloc/constant/base_controller.dart';
import 'package:inventory_tracker/database/model/history_model.dart';
import 'package:inventory_tracker/database/model/inventory_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/utils/gsheet_handler.dart';

enum PanelEnum { history, inventory }

abstract class HistoryViewBlocInterface {
  void push(dynamic data);

  void clear(PanelEnum type);
}

class HistoryViewBloc extends BaseStreamController<List>
    implements BaseInterface<List>, HistoryViewBlocInterface {
  late final BehaviorSubject<List<History>> histories;
  late final BehaviorSubject<List<Inventory>> bookmarks;
  final SheetHandlerMain? handler;
  final Box? hiveHistoryBox;
  final Box? hiveBookMarkBox;

  HistoryViewBloc({
    required state,
    required PanelEnum type,
    this.hiveHistoryBox,
    this.hiveBookMarkBox,
    this.handler,
  }) : super(state: state) {
    if (type == PanelEnum.history) {
      histories = BehaviorSubject<List<History>>.seeded(state);
    } else if (type == PanelEnum.inventory) {
      bookmarks = BehaviorSubject<List<Inventory>>.seeded(state);
    }
  }

  Stream<List<History>> get historyStream => histories.stream;

  Stream<List<Inventory>> get bookMarkStream => bookmarks.stream;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<List> get stream {
    return CombineLatestStream.combine2(
        historyStream, bookMarkStream, (List a, List b) => [...a, ...b]);
  }

  @override
  Future<void> push([dynamic data]) async {
    if (data is History) {
      histories.add([...histories.value, data].toSet().toList());
    } else {
      final newState = await handler?.fetchData(SheetType.inventory);
      bookmarks.add(newState!
          .cast<Inventory>()
          .where((element) => element.bookMark == true)
          .toList());
    }
  }

  @override
  void clear(PanelEnum type) {
    if (type == PanelEnum.history) {
      histories.add([]);
    } else if (type == PanelEnum.inventory) {}
  }
}
