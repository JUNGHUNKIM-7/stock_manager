import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/model/history_model.dart';
import '../../database/model/inventory_model.dart';
import 'blocs_container.dart';

class BlocsCombiner extends Blocs
    with BlocsCombinerMixins
    implements BlocsCombinerInterface {
  BlocsCombiner({
    required Map<String,dynamic> handlerMap,
    List<History>? historyData,
    List<Inventory>? inventoryData,
    Box? settingsBox,
  }) : super.initializer(
          settingBox: settingsBox ?? Hive.box('settings'),
          handlerMap: handlerMap,
          historyData: historyData ?? [],
          inventoryData: inventoryData ?? [],
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
  Stream<List<History>> get filterHisByYear => CombineLatestStream.combine2(
        historyBloc.stream,
        yearSelection.yearStream,
        (List<History> historyData, int year) => historyData
            .where((element) =>
                int.tryParse(element.date!.substring(0, 4)) == year)
            .toList(),
      );

  @override
  Stream<List<History>> get filterHisByParams =>
      CombineLatestStream.combine2(filterHisByYear, historySearchBloc.stream,
          (List<History> historyData, String searchParams) {
        if (searchParams.isNotEmpty) {
          return historyData
              .where(
                (element) => element.title
                    .toLowerCase()
                    .contains(searchParams.toLowerCase()),
              )
              .toList();
        }
        return historyData.toList();
      }).transform(historyNotEmpty);

  @override
  Stream<List<History>> get filterHisByStatus => CombineLatestStream.combine5(
          filterHisByParams,
          chipBloc.stream,
          inStatus.stream,
          outStatus.stream,
          descendingStatus.stream, (List<History> historyData, int chipIdx,
              bool inStatus, bool outStatus, bool descendingStatus) {
        bool matchChipIdx(element) {
          return int.tryParse(element.date!.split('T')[0].split('-')[1]) ==
              (chipIdx + 1);
        }

        bool matchChipAndOutStatus(element) {
          return element.status.toLowerCase() == 'y' && matchChipIdx(element);
        }

        bool matchChipAndInStatus(element) {
          return element.status.toLowerCase() == 'n' && matchChipIdx(element);
        }

        List<History> getDataByChipIdx([bool? reverse]) {
          switch (reverse) {
            case true:
              return historyData.reversed.where(matchChipIdx).toList();
            case false:
              return historyData.where(matchChipIdx).toList();
            default:
              throw Exception('Invalid chipIdx');
          }
        }

        List<History> getDataByStatus([String? status, bool? reverse]) {
          switch (status) {
            case 'n':
              if (reverse == true) {
                return historyData.reversed
                    .where(matchChipAndInStatus)
                    .toList();
              } else {
                return historyData.where(matchChipAndInStatus).toList();
              }
            case 'y':
              if (reverse == true) {
                return historyData.reversed
                    .where(matchChipAndOutStatus)
                    .toList();
              } else {
                return historyData.where(matchChipAndOutStatus).toList();
              }
            default:
              throw Exception('Invalid chipIdx');
          }
        }

        if (descendingStatus == true) {
          if (inStatus == true && outStatus == true) {
            return getDataByChipIdx(true);
          } else if (inStatus == true && outStatus == false) {
            return getDataByStatus('n', true);
          } else if (outStatus == true && inStatus == false) {
            return getDataByStatus('y', true);
          }
        } else {
          if (inStatus == true && outStatus == true) {
            return getDataByChipIdx(false);
          } else if (inStatus == true && outStatus == false) {
            return getDataByStatus('n', false);
          } else if (outStatus == true && inStatus == false) {
            return getDataByStatus('y', false);
          }
        }
        throw Exception('There is No Filters');
      }).transform(historyNotEmpty);

  @override
  Stream<List<Inventory>> get filterInventoryStream =>
      CombineLatestStream.combine2(
        inventoryBloc.stream,
        inventorySearchBloc.stream,
        (List<Inventory> inventoryData, String searchParams) => inventoryData
            .reversed
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

  Stream<List<History>> get filterHisByYear;

  Stream<List<History>> get filterHisByParams;

  Stream<List<dynamic>> get filterHisByStatus;

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
