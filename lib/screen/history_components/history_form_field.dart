import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';
import 'package:stock_manager/screen/global_components/dark_mode_container.dart';

import '../../styles.dart';

class HistoryFormField extends StatelessWidget {
  const HistoryFormField({
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
                  return HistoryFormFields(
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

class HistoryFormFields extends StatelessWidget {
  const HistoryFormFields({
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
