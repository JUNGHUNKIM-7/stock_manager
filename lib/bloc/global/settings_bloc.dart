import 'package:hive/hive.dart';

import '../constant/base_controller.dart';

abstract class SettingsBlocInterface {
  void catchTZValue(String value);

  void catchSheetId(String value);

  void catchCredential(String value);
}

mixin SettingsMixin<T extends Map<String, dynamic>> {}

class SettingsBloc extends BaseStreamController<Map<String, dynamic>>
    with SettingsMixin
    implements BaseInterface<Map<String, dynamic>>, SettingsBlocInterface {
  SettingsBloc({required state, required this.settingBox})
      : super(state: state);
  final Box settingBox;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<Map<String, dynamic>> get stream => subject.stream;

  @override
  void catchCredential(String value) {
    settingBox.put('secret', value);
    state['secret'] = settingBox.get('secret');
    print(settingBox.get('secret'));
  }

  @override
  void catchSheetId(String value) {
    settingBox.put('sheetId', value);
    state['sheetId'] = settingBox.get('sheetId');
    print(settingBox.get('sheetId'));
  }

  @override
  void catchTZValue(String value) {
    settingBox.put('tz', value);
    state['tz'] = settingBox.get('tz');
  }
}
