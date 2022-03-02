import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_sheet_stock_manager/database/in_app_purchase/purchase_api.dart';
import 'package:qr_sheet_stock_manager/database/utils/secret.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'database/utils/hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Hive.initFlutter();
  await Future.wait([
    dotenv.load(fileName: '.env'),
    HiveHandler.initialize(),
    SecretHandler.initialize(),
  ]);

  await RunApp.runApplication();
}
