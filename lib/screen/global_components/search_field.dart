import 'package:flutter/material.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../styles.dart';

//화면이동시, 검색어에 따라 bloc 상태가 남아있음.
//화면전환시에 bloc 초기화

class SearchField extends StatefulWidget {
  const SearchField({Key? key, required this.type, required this.hintText})
      : super(key: key);

  final String type;
  final String hintText;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final bloc = getSearchBloc(context, widget.type);
      if (_controller.text.isNotEmpty) {
        bloc.onChanged(_controller.text.trim().toLowerCase());
      } else {
        bloc.onChanged('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getSearchBloc(context, widget.type);

    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: innerSpace * 2),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: _controller,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    labelText: widget.hintText,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .headline2
                        ?.copyWith(fontSize: 16),
                    hintText: '"Your Item Name?"',
                    hintStyle: const TextStyle(fontSize: 14.0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      iconSize: 26,
                      splashColor: Colors.red,
                      onPressed: _controller.text.isNotEmpty
                          ? () {
                              _controller.clear();
                              bloc.onChanged('');
                            }
                          : null,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            );
          }
          return Container();
        });
  }

  getSearchBloc(BuildContext context, String type) {
    switch (type) {
      case 'history':
        return BlocProvider.of<BlocsCombiner>(context).historySearchBloc;
      case 'inventory':
        return BlocProvider.of<BlocsCombiner>(context).inventorySearchBloc;
      default:
        throw Exception('Err: SearchField');
    }
  }

  // @override
  // void deactivate() {
  //   _controller.clear();
  //   super.deactivate();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
// todo when press X
// I/TextInputPlugin( 7521): Composing region changed by the framework. Restarting the input method.
// W/IInputConnectionWrapper( 7521): getTextBeforeCursor on inactive InputConnection
// W/IInputConnectionWrapper( 7521): getSelectedText on inactive InputConnection
// W/IInputConnectionWrapper( 7521): getTextAfterCursor on inactive InputConnection
