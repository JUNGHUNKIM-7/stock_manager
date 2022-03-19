import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_tracker/bloc/global/theme_bloc.dart';

import '../../styles.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton(
      {Key? key, required this.snapshot, required this.theme})
      : super(key: key);
  final AsyncSnapshot<bool> snapshot;
  final ThemeBloc theme;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        context.goNamed('subscription');
      },
      icon: Icon(
        Icons.attach_money,
        size: 30,
        color: snapshot.data ?? false ? Styles.lightColor : Styles.darkColor,
      ),
      label: Text(
        'Subscription',
        style: Theme.of(context).textTheme.headline3?.copyWith(
            fontSize: 16,
            color:
                snapshot.data ?? false ? Styles.lightColor : Styles.darkColor),
      ),
    );
  }
}
