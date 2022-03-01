import 'package:hive/hive.dart';
import 'package:qr_sheet_stock_manager/bloc/constant/base_controller.dart';

abstract class ThemeBlocInterface {
  void darkMode();
}

class ThemeBloc extends BaseStreamController<bool>
    implements BaseInterface<bool>, ThemeBlocInterface {
  ThemeBloc({required state, required this.settingBox}) : super(state: state);

  final Box settingBox;

  @override
  void darkMode() {
    final currentMode = (settingBox.get('darkMode') ?? false) as bool;
    settingBox.put('darkMode', !currentMode);
    state = settingBox.get('darkMode');
  }

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<bool> get stream => subject.stream;
}