import 'dart:convert';

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
  SettingsBloc({
    required state,
    required this.settingBox,
    required this.handlerMap,
  }) : super(state: state);
  final Box settingBox;
  final Map<String, dynamic> handlerMap;

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<Map<String, dynamic>> get stream => subject.stream;

  @override
  void catchCredential(String value) async {
    final List<int> secretKey = handlerMap['key'];
    final Future<Box> Function(List<int>) futureSecretBox = handlerMap['box'];
    final Box secretBox = await futureSecretBox(secretKey);

    final Map<String, dynamic> userCredentials = jsonDecode(value);

    await Future.wait([
      settingBox.put('secret', secretKey),
      settingBox
          .put('secretWithoutKey', {...userCredentials, 'private_key': ''}),
      secretBox.put('secret', userCredentials['private_key'])
    ]);
    state['secret'] = settingBox.get('secret');
  }

  @override
  void catchSheetId(String value) {
    settingBox.put('sheetId', value);
    state['sheetId'] = settingBox.get('sheetId');
  }

  @override
  void catchTZValue(String value) {
    settingBox.put('tz', value);
    state['tz'] = settingBox.get('tz');
  }
}
