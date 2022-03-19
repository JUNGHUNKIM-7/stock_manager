import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_tracker/database/in_app_purchase/purchase_api.dart';
import 'package:inventory_tracker/database/utils/secret.dart';
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

  await purchaseApi.init();
  await purchaseApi.getUserStatus();

  await RunApp.runApplication(purchaseApi.getSubStatusBloc);
}
