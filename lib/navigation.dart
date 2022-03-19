import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_tracker/database/in_app_purchase/subscription_plans.dart';
import 'package:inventory_tracker/database/model/history_model.dart';
import 'package:inventory_tracker/screen/bottom_nav_components/bottom_nav_home.dart';
import 'package:inventory_tracker/screen/history_components/history_details.dart';
import 'package:inventory_tracker/screen/history_components/history_form.dart';
import 'package:inventory_tracker/screen/inventory_components/inventory_details.dart';
import 'package:inventory_tracker/screen/inventory_components/inventory_form_group.dart';
import 'package:inventory_tracker/screen/markdown/features_markdown.dart';
import 'package:inventory_tracker/screen/markdown/manual_markdown.dart';
import 'package:inventory_tracker/screen/qr_camera_components/qr_camera.dart';

import 'database/model/inventory_model.dart';

GoRouter getRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const TabNavHome(),
      ),
      GoRoute(
        name: 'manual',
        path: '/manual',
        builder: (context, state) => const ManualMarkdown(),
      ),
      GoRoute(
        name: 'features',
        path: '/features',
        builder: (context, state) => const FeaturesMarkdown(),
      ),
      GoRoute(
        name: 'subscription',
        path: '/subscription',
        builder: (context, state) => const SubscriptionPlans(),
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
