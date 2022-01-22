import 'package:flutter/material.dart';

class LinedBtn extends StatelessWidget {
  const LinedBtn({
    Key? key,
    required this.text,
    this.onPressed,
    this.bloc,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;
  final dynamic bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc?.stream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return OutlinedButton(
            style: snapshot.data == true
                ? ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent))
                : ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
            onPressed: onPressed,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        });
  }
}
