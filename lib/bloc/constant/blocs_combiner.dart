import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import 'blocs_container.dart';

class BlocsCombiner extends Blocs
    with BlocsCombinerMixins
    implements BlocsCombinerInterface {
  BlocsCombiner({required Map<String, List> fetchedData, Box? settingsBox})
      : super.initializer(
          settingBox: settingsBox ?? Hive.box('settings'),
          historyData: (fetchedData['history']?.isEmpty != true)
              ? fetchedData['history'] as List<History>
              : [],
          inventoryData: (fetchedData['inventory']?.isEmpty != true)
              ? fetchedData['inventory'] as List<Inventory>
              : [],
        );

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
  Stream<List<History>> get filterStreamByYear => CombineLatestStream.combine2(
        historyBloc.stream,
        yearSelection.yearStream,
        (List<History> historyData, int year) => historyData.reversed
            .where(
                (element) => element.date!.substring(0, 4) == year.toString())
            .toList(),
      );

  @override
  Stream<List<History>> get filteredHistoryStream =>
      CombineLatestStream.combine3(
          filterStreamByYear, chipBloc.stream, historySearchBloc.stream,
          (List<History> historyData, int chipIdx, String searchParams) {
        final filteredByMonth = historyData.reversed.where(
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
      CombineLatestStream.combine4(filteredHistoryStream, inStatus.stream,
          outStatus.stream, descendingStatus.stream, (List<History> historyData,
              bool inStatus, bool outStatus, bool descendingStatus) {
        if (inStatus && outStatus) {
          if (descendingStatus == true) {
            return historyData.reversed.toList();
          } else {
            return historyData;
          }
        } else if (inStatus == true) {
          if (descendingStatus == true) {
            return historyData.reversed
                .where((element) => element.status.toLowerCase() == 'n')
                .toList();
          } else {
            return historyData
                .where((element) => element.status.toLowerCase() == 'n')
                .toList();
          }
        } else if (outStatus == true) {
          if (descendingStatus == true) {
            return historyData.reversed
                .where((element) => element.status.toLowerCase() == 'y')
                .toList();
          } else {
            return historyData
                .where((element) => element.status.toLowerCase() == 'y')
                .toList();
          }
        } else {
          throw Exception('There is No Filters');
        }
      }).transform(historyNotEmpty);

  @override
  Stream<List<Inventory>> get filterInventoryStream =>
      CombineLatestStream.combine2(
        inventoryBloc.stream,
        inventorySearchBloc.stream,
        (List<Inventory> inventoryData, String searchParams) => inventoryData
            .where(
                (element) => element.title.toLowerCase().contains(searchParams))
            .toList(),
      ).transform(inventoryNotEmpty);

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

  Stream<List<History>> get filterStreamByYear;

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
