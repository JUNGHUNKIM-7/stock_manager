import 'package:flutter/material.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/screen/global_components/dark_mode_container.dart';
import '../../styles.dart';

class FormGroup extends StatefulWidget {
  const FormGroup({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  @override
  Widget build(BuildContext context) {
    return DarkModeContainer(
      height: 0.55,
      child: Form(
        key: widget.formKey,
        // autovalidateMode: AutovalidateMode.always,
        child: Wrap(
          children: List<Widget>.generate(
            InputDeco.icons.length,
            (int idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: innerSpace, vertical: innerSpace),
                child: DarkModeContainer(
                  reverse: true,
                  height: 0.15,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: innerSpace),
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
          // onSaved: (String? value) {
          //
          // },
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
