import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/constant/blocs_combiner.dart';
import '../../bloc/constant/provider.dart';
import '../../database/utils/gsheet_handler.dart';
import '../../screen/global_components/appbar_wrapper.dart';
import '../../styles.dart';
import 'inventory_form_btn.dart';
import 'inventory_form_field.dart';

class InventoryForm extends StatelessWidget {
  InventoryForm({Key? key}) : super(key: key);
  final _uuid = const Uuid();
  final _handler = SheetHandlerMain();

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(
            context: context, combiner: combiner, typeOfForm: 'inventory'),
        body: ListView(
          children: [
            const SizedBox(
              height: outerSpacing,
            ),
            Center(
              child: Text(
                'Add Item Form'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: outerSpacing),
              child: InventoryFormGroup(),
            ),
            const SizedBox(
              height: outerSpacing * 2,
            ),
            Center(
              child: InventorySubmit(
                  combiner: combiner, uuid: _uuid, handler: _handler),
            ),
          ],
        ),
      ),
    );
  }
}
