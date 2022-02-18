import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_manager/database/secret/secret.dart';
import 'package:stock_manager/utils/debugging.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'database/hive_storage/histories.dart';
import 'database/hive_storage/hive_handler.dart';
import 'database/hive_storage/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Future.wait([
    Hive.initFlutter(),
    HiveHandler.init(),
    SecretHandler.initialize(),
  ]);

  HiveHandler.registerAdapter([
    SettingsAdapter(),
    HistoriesAdapter(),
  ]);

  await HiveHandler.openRegisteredBox([
    'settings',
    'histories',
  ]);

  await runApplication();
}
