import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import 'blocs_container.dart';

class BlocsCombiner extends Blocs
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
          bookMarkData: fetchedData != null
              ? fetchedData['bookmark'] as List<Inventory>
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
    titleFieldBloc.dispose();
    memoFieldBloc.dispose();
    qtyFieldBloc.dispose();
  }

  @override
  Stream<List<History>> get filteredHistoryStream =>
      CombineLatestStream.combine4(yearSelection.yearStream, chipBloc.stream,
          historyBloc.stream, historySearchBloc.stream, (int year, int chipIdx,
              List<History> historyData, String searchParams) {
        final filterByYear = historyData.where(
            (element) => element.date!.substring(0, 4) == year.toString());

        final filteredByMonth = filterByYear.where(
          (element) => element.date!
              .split(' ')[0]
              .split('-')[1]
              .contains((chipIdx + 1).toString()),
        );

        if (searchParams.isNotEmpty) {
          return filteredByMonth
              .where(
                (element) => element.title.toLowerCase().contains(searchParams),
              )
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
              .where((element) => element.status.toLowerCase() == 'n')
              .toList();
        } else if (outStatus == true) {
          return historyData
              .where((element) => element.status.toLowerCase() == 'y')
              .toList();
        } else {
          return historyData;
        }
      }).transform(historyNotEmpty);

  @override
  Stream<List<Inventory>> get filterInventoryStream =>
      CombineLatestStream.combine2(
          inventoryBloc.stream,
          inventorySearchBloc.stream,
          (List<Inventory> inventoryData, String searchParams) => inventoryData
              .where(
                (element) => element.title.toLowerCase().contains(searchParams),
              )
              .toList()).transform(inventoryNotEmpty);

  @override
  Stream<Map<String, dynamic>> get inventoryAddFormStream =>
      CombineLatestStream.combine3(titleFieldBloc.titleStream!,
          memoFieldBloc.memoStream!, qtyFieldBloc.qtyStream!, (
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
        throw Exception('qty Error');
      });

  @override
  Stream<Map<String, dynamic>> get historyAddFormStream =>
      CombineLatestStream.combine2(
          statusFieldBloc.outStream!, valFieldBloc.valStream!, (
        String status,
        String val,
      ) {
        if (!int.parse(val).isNegative &&
            !val.contains(RegExp(r'^[a-zA-Z]+$'))) {
          return {
            'status': status,
            'val': int.parse(val),
          };
        }
        throw Exception('val Error');
      });
}

abstract class BlocsCombinerInterface {
  void disposeFirstPage();

  void disposeSecondPage();

  void disposeForm();

  Stream<List<History>> get filteredHistoryStream;

  Stream<List<History>> get filteredHistoryStreamWithStatus;

  Stream<List<Inventory>> get filterInventoryStream;

  Stream<Map<String, dynamic>> get inventoryAddFormStream;

  Stream<Map<String, dynamic>> get historyAddFormStream;
}

mixin BlocsCombinerMixins {
  final historyNotEmpty =
      StreamTransformer<List<History>, List<History>>.fromHandlers(
    handleData: (List<History> data, EventSink<List<History>> sink) {
      if (data.isNotEmpty) {
        sink.add(data);
      } else {
        sink.addError('No History Data');
      }
    },
  );

  final inventoryNotEmpty =
      StreamTransformer<List<Inventory>, List<Inventory>>.fromHandlers(
    handleData: (List<Inventory> data, EventSink<List<Inventory>> sink) {
      if (data.isNotEmpty) {
        sink.add(data);
      } else {
        sink.addError('No Inventory Data');
      }
    },
  );
}