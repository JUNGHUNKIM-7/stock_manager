import 'package:flutter/material.dart';
import 'package:inventory_tracker/bloc/global/form_bloc.dart';
import 'package:inventory_tracker/screen/global_components/dark_mode_container.dart';

import '../../styles.dart';

class HistoryFormFields extends StatelessWidget {
  const HistoryFormFields({
    Key? key,
    required this.val,
  }) : super(key: key);

  final FormBloc val;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: innerSpacing, vertical: innerSpacing),
        child: DarkModeContainer(
          reverse: true,
          height: 0.15,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: innerSpacing),
            child: StreamBuilder(
                stream: val.valStream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return ValueField(
                    val: val,
                    snapshot: snapshot,
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class ValueField extends StatelessWidget {
  const ValueField({
    Key? key,
    required this.val,
    required this.snapshot,
  }) : super(key: key);
  final FormBloc val;
  final AsyncSnapshot<String> snapshot;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        val.getValue(value, FormFields.val);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyText1,
        labelStyle: Theme.of(context).textTheme.bodyText1,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        icon: Icon(HistoryInputDeco.icons[0]),
        hintText: HistoryInputDeco.hintText[0],
        labelText: HistoryInputDeco.texts[0],
        errorText: snapshot.hasError ? snapshot.error.toString() : null,
      ),
    );
  }
}

class HistoryInputDeco {
  static const icons = [
    Icons.title,
  ];

  static const texts = [
    'Value',
  ];

  static const hintText = [
    'Applying Value?',
  ];
}
