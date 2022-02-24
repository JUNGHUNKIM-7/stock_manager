import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_sheet_stock_manager/database/secret/secret.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'database/hive_utils/hive_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Hive.initFlutter();
  await Future.wait([
    HiveHandler.initialize(),
    SecretHandler.initialize(),
  ]);

  await runApplication();
}
