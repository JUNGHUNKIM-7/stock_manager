import 'package:router_go/database/model/history_model.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../../bloc/atom_blocs/form_control.dart';
import '../../bloc/atom_blocs/form_control_memo.dart';
import '../../bloc/atom_blocs/in_out_status.dart';
import '../../bloc/atom_blocs/inventory_bloc.dart';
import '../../bloc/atom_blocs/inventory_search_bloc.dart';
import '../../bloc/atom_blocs/filter_chip_bloc.dart';
import '../../bloc/atom_blocs/history_bloc.dart';
import '../../bloc/atom_blocs/page_bloc.dart';
import '../../bloc/atom_blocs/history_search_bloc.dart';
import '../../bloc/atom_blocs/theme_bloc.dart';

class _Blocs {
  _Blocs._();

  _Blocs.initializer({required this.historyData, required this.inventoryData}) {
    historyData = historyData;
    inventoryData = inventoryData;
  }

  late List<History> historyData;
  late List<Inventory> inventoryData;

  final themeBloc = ThemeBloc(state: false);
  final pageBloc = PageBloc(state: 0);

  final chipBloc = ChipBloc(state: 0);
  late final historyBloc =
      HistoryBloc(state: historyData, handler: GSheetHandler());
  final historySearchBloc = HistorySearchBloc(state: '');

  late final inventoryBloc =
      InventoryBloc(state: inventoryData, handler: GSheetHandler());
  final inventorySearchBloc = InventorySearchBloc(state: '');
  final inStatus = FilterButtonStatusBloc(state: true);
  final outStatus = FilterButtonStatusBloc(state: true);

  final titleField = FormControlBloc(state: '');
  final memoField = MemoFieldBloc(state: '');
  final qtyField = FormControlBloc(state: '');
}

class BlocsCombiner extends _Blocs
    with BlocsCombinerMixins
    implements BlocsCombinerInterface {
  BlocsCombiner({this.fetchedData})
      : super.initializer(
          historyData: fetchedData != null
              ? fetchedData['history'] as List<History>
              : [],
          inventoryData: fetchedData != null
              ? fetchedData['inventory'] as List<Inventory>
              : [],
        );

  final Map<String, List>? fetchedData;

  @override
  void disposeFirstPage() {
    chipBloc.dispose();
    historySearchBloc.dispose();
    historyBloc.dispose();
  }

  @override
  void disposeSecondPage() {
    inventoryBloc.dispose();
    inventorySearchBloc.dispose();
  }

  @override
  void disposeForm() {
    titleField.dispose();
    memoField.dispose();
    qtyField.dispose();
  }

  @override
  Stream<List<History>> get filteredHistoryStream =>
      CombineLatestStream.combine3(
          chipBloc.stream, historyBloc.stream, historySearchBloc.stream,
          (int chipIdx, List<History> historyData, String searchParams) {
        final filteredByMonth = historyData.where((element) =>
            element.date!.substring(4, 6).contains((chipIdx + 1).toString()));

        if (searchParams.isNotEmpty) {
          return filteredByMonth
              .where((element) =>
                  element.title.toLowerCase().contains(searchParams))
              .toList();
        }
        return filteredByMonth.toList();
      }).transform(historyNotEmpty);

  @override
  Stream<List<History>> get filteredHistoryStreamWithStatus =>
      CombineLatestStream.combine3(
          filteredHistoryStream, inStatus.stream, outStatus.stream,
          (List<History> historyData, bool inStatus, bool outStatus) {
        if (inStatus && outStatus) {
          return historyData;
        } else if (inStatus == true) {
          return historyData
              .where((element) => element.out.toLowerCase() == 'n')
              .toList();
        } else if (outStatus == true) {
          return historyData
              .where((element) => element.out.toLowerCase() == 'y')
              .toList();
        } else {
          return historyData;
        }
      }).transform(historyNotEmpty);

  @override
  Stream<List<Inventory>>
      get filterInventoryStream => CombineLatestStream.combine2(
          inventoryBloc.stream,
          inventorySearchBloc.stream,
          (List<Inventory> inventoryData, String searchParams) => inventoryData
              .where((element) =>
                  element.title.toLowerCase().contains(searchParams))
              .toList()).transform(inventoryNotEmpty);

  @override
  Stream<Map<String, dynamic>> get formStreams => CombineLatestStream.combine3(
          titleField.stream, memoField.stream, qtyField.stream, (
        String title,
        String? memo,
        String qty,
      ) {
        if (!int.parse(qty).isNegative &&
            !qty.contains(RegExp(r'^[a-zA-Z]+$'))) {
          return {
            'title': title,
            'memo': memo ?? '',
            'qty': int.parse(qty),
          };
        }
        throw Exception('Form Data Error');
      });
}

abstract class BlocsCombinerInterface {
  void disposeFirstPage();

  void disposeSecondPage();

  void disposeForm();

  Stream<List<History>> get filteredHistoryStream;

  Stream<List<History>> get filteredHistoryStreamWithStatus;

  Stream<List<Inventory>> get filterInventoryStream;

  Stream<Map<String, dynamic>> get formStreams;
}

mixin BlocsCombinerMixins {
  final historyNotEmpty =
      StreamTransformer<List<History>, List<History>>.fromHandlers(
    handleData: (List<History> data, EventSink<List<History>> sink) {
      if (data.isNotEmpty) {
        sink.add(data);
      } else {
        sink.addError('NO HISTORY DATA');
      }
    },
  );

  final inventoryNotEmpty =
      StreamTransformer<List<Inventory>, List<Inventory>>.fromHandlers(
    handleData: (List<Inventory> data, EventSink<List<Inventory>> sink) {
      if (data.isNotEmpty) {
        sink.add(data);
      } else {
        sink.addError('ITEM ISN\'T EXIST');
      }
    },
  );
}
