import 'package:qr_sheet_stock_manager/bloc/constant/base_controller.dart';
import 'package:rxdart/rxdart.dart';

abstract class YearSelectionBlocInterface {
  Stream<int> get yearStream;

  void catchYear(int val);
}

class YearSelectionBloc extends BaseStreamController<int>
    implements BaseInterface<int>, YearSelectionBlocInterface {
  late BehaviorSubject<int> changeableYear;

  YearSelectionBloc({required state}) : super(state: state) {
    changeableYear = BehaviorSubject<int>.seeded(state);
  }

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<int> get stream => subject.stream;

  @override
  Stream<int> get yearStream => changeableYear.stream;

  @override
  void catchYear(int val) {
    changeableYear.add(val);
  }
}
