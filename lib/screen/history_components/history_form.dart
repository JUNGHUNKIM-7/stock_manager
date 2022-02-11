import 'package:flutter/material.dart';
import 'package:router_go/bloc/constant/blocs_combiner.dart';
import 'package:router_go/bloc/constant/provider.dart';
import 'package:router_go/database/model/inventory_model.dart';
import 'package:router_go/database/repository/gsheet_handler.dart';
import 'package:router_go/screen/global_components/appbar_icons.dart';
import 'package:router_go/screen/global_components/dark_mode_container.dart';

import '../../styles.dart';
import 'history_form_btn.dart';
import 'history_form_header.dart';

class HistoryForm extends StatelessWidget {
  HistoryForm({Key? key, required this.inventory}) : super(key: key);
  final Inventory inventory;
  final GSheetHandler _handler = GSheetHandler();

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);
    final out = BlocProvider.of<BlocsCombiner>(context).statusFieldBloc;
    final val = BlocProvider.of<BlocsCombiner>(context).valFieldBloc;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(
            context: context, combiner: combiner, typeOfForm: 'history'),
        body: ListView(
          children: [
            const SizedBox(
              height: outerSpacing,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: Center(
                child: Text(
                  'Make Order'.toUpperCase(),
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontSize: 26,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: outerSpacing * 1.5),
              child: DarkModeContainer(
                height: height * 0.0008,
                child:
                    HistoryInfoCard(inventory: inventory, out: out, val: val),
              ),
            ),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            Center(
              child: SubmitHistory(handler: _handler, inventory: inventory),
            ),
          ],
        ),
      ),
    );
  }
}
