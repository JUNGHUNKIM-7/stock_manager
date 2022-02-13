import 'package:flutter/material.dart';
import 'package:stock_manager/bloc/global/form_bloc.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../screen/global_components/dark_mode_container.dart';
import '../../styles.dart';

class InventoryFormGroup extends StatelessWidget {
  const InventoryFormGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DarkModeContainer(
      height: 0.55,
      child: Form(
        child: Wrap(
          children: List<Widget>.generate(
            InventoryInputDeco.icons.length,
            (int idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: innerSpacing, vertical: innerSpacing),
                child: DarkModeContainer(
                  reverse: true,
                  height: 0.15,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: innerSpacing),
                    child: InventoryFormFields(idx: idx),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class InventoryFormFields extends StatelessWidget {
  const InventoryFormFields({Key? key, required this.idx}) : super(key: key);
  final int idx;

  @override
  Widget build(BuildContext context) {
    final title = BlocProvider.of<BlocsCombiner>(context).titleFieldBloc;
    final memo = BlocProvider.of<BlocsCombiner>(context).memoFieldBloc;
    final qty = BlocProvider.of<BlocsCombiner>(context).qtyFieldBloc;

    return StreamBuilder(
      stream: idx == 0
          ? title.titleStream
          : idx == 1
              ? memo.memoStream
              : idx == 2
                  ? qty.qtyStream
                  : null,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        return TextFormField(
          onChanged: (String value) {
            switch (idx) {
              case 0:
                title.getValue(value, FormFields.title);
                break;
              case 1:
                memo.getValue(value, FormFields.memo);
                break;
              case 2:
                qty.getValue(value, FormFields.qty);
                break;
            }
          },
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyText1,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            icon: Icon(InventoryInputDeco.icons[idx]),
            hintText: InventoryInputDeco.hintText[idx],
            labelText: InventoryInputDeco.texts[idx],
            errorText: idx == 1
                ? null
                : snapshot.hasError
                    ? snapshot.error.toString()
                    : null,
          ),
          keyboardType: idx == 2 ? TextInputType.number : TextInputType.text,
        );
      },
    );
  }
}

class InventoryInputDeco {
  static const icons = [
    Icons.short_text_rounded,
    Icons.note_alt_outlined,
    Icons.arrow_circle_up_outlined,
  ];

  static const texts = [
    'Product',
    'Memo',
    'Quantity',
  ];

  static const hintText = [
    'Product Name?',
    'Product Memo?',
    'Product Quantity?',
  ];
}
