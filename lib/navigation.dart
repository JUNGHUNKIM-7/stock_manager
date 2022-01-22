import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:router_go/screen/bottom_nav_components/bottom_nav_home.dart';
import 'package:router_go/screen/inventory_components/inventory_form_group.dart';
import 'package:router_go/screen/inventory_components/qr_page.dart';

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
          name: 'check_qr',
          path: '/check_qr',
          builder: (context, state) {
            return QrPage(inventory: state.extra! as Inventory);
          }),
      GoRoute(
        name: 'addItem',
        path: '/add_item',
        builder: (context, state) => const InventoryForm(),
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
