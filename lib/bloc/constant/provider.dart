import 'package:flutter/material.dart';

class BlocProvider<T> extends InheritedWidget {
  const BlocProvider({Key? key, required Widget child, required T combiner})
      : _combiner = combiner,
        super(key: key, child: child);

  final T _combiner;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static U of<U>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlocProvider<U>>()!
        ._combiner;
  }
}
