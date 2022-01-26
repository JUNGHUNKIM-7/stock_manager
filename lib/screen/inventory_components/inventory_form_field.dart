import 'package:flutter/material.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../screen/global_components/dark_mode_container.dart';
import '../../styles.dart';

class FormGroup extends StatelessWidget {
  const FormGroup({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return DarkModeContainer(
      height: 0.55,
      child: Form(
        key: formKey,
        child: Wrap(
          children: List<Widget>.generate(
            InputDeco.icons.length,
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
                    child: TextFormFields(idx: idx),
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

class TextFormFields extends StatelessWidget {
  const TextFormFields({Key? key, required this.idx}) : super(key: key);
  final int idx;

  @override
  Widget build(BuildContext context) {
    final title = BlocProvider.of<BlocsCombiner>(context).titleField;
    final memo = BlocProvider.of<BlocsCombiner>(context).memoField;
    final qty = BlocProvider.of<BlocsCombiner>(context).qtyField;

    return StreamBuilder(
      stream: idx == 0
          ? title.stream
          : idx == 1
              ? memo.stream
              : idx == 2
                  ? qty.stream
                  : null,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        return TextFormField(
          onChanged: (value) {
            switch (idx) {
              case 0:
                title.getValue(value);
                break;
              case 1:
                memo.getValue(value);
                break;
              case 2:
                qty.getValue(value);
                break;
            }
          },
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyText2,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            icon: Icon(InputDeco.icons[idx]),
            hintText: InputDeco.hintText[idx],
            labelText: InputDeco.texts[idx],
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

class InputDeco {
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
