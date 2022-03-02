import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../styles.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({Key? key, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot<bool> snapshot;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.goNamed('subscription');
      },
      icon: Icon(
        Icons.subscriptions,
        size: 30,
        color: snapshot.data == true ? Styles.lightColor : Styles.darkColor,
      ),
      label: Text(
        'Plans',
        style: Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
      ),
    );
  }
}
