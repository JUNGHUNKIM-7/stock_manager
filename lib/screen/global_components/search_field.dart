import 'package:flutter/material.dart';
import 'package:router_go/screen/global_components/years_picker.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key, required this.type, required this.hintText})
      : super(key: key);

  final String type;
  final String hintText;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getSearchBloc(context, widget.type);

    return StreamBuilder(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return TextField(
              onChanged: (String val) {
                bloc.onChanged(val);
              },
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
                  hintText: '"Product Name?"',
                  hintStyle: const TextStyle(fontSize: 14.0),
                  suffixIcon: snapshot.data!.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          iconSize: 26,
                          splashColor: Colors.red,
                          onPressed: _controller.text.isNotEmpty
                              ? () {
                                  _controller.clear();
                                  bloc.onChanged('');
                                }
                              : null,
                        )
                      : null,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
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

  @override
  void dispose() {
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }
}

