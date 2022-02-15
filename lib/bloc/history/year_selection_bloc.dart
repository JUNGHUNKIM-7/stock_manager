import 'package:rxdart/rxdart.dart';
import 'package:stock_manager/bloc/constant/base_controller.dart';

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
