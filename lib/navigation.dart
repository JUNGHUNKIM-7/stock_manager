import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_manager/database/model/history_model.dart';
import 'package:stock_manager/screen/bottom_nav_components/bottom_nav_home.dart';
import 'package:stock_manager/screen/history_components/history_details.dart';
import 'package:stock_manager/screen/history_components/history_form.dart';
import 'package:stock_manager/screen/inventory_components/inventory_details.dart';
import 'package:stock_manager/screen/inventory_components/inventory_form_group.dart';
import 'package:stock_manager/screen/qr_camera_components/qr_camera.dart';

import 'database/model/inventory_model.dart';

class PageRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const TabNavHome(),
      ),
      GoRoute(
        name: 'historyDetails',
        path: '/historyDetails',
        builder: (context, state) =>
            HistoryDetails(history: state.extra! as History),
      ),
      GoRoute(
        name: 'inventoryDetails',
        path: '/inventoryDetails',
        builder: (context, state) =>
            InventoryDetails(inventory: state.extra! as Inventory),
      ),
      GoRoute(
        name: 'historyForm',
        path: '/history_form',
        builder: (context, state) =>
            HistoryForm(inventory: state.extra! as Inventory),
      ),
      GoRoute(
        name: 'inventoryForm',
        path: '/inventory_form',
        builder: (context, state) => InventoryForm(),
      ),
      GoRoute(
        name: 'qrCamera',
        path: '/qr_camera',
        builder: (context, state) => const QrCamera(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(
      error: state.error,
    ),
  );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.error}) : super(key: key);
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(child: Text('Error: ${error?.toString()}')),
      ),
    );
  }
}
