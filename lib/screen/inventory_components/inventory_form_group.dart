import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'inventory_form_btn.dart';
import 'inventory_form_field.dart';

import '../../bloc/constant/provider.dart';
import '../../bloc/constant/blocs_combiner.dart';
import '../../database/repository/gsheet_handler.dart';
import '../../screen/global_components/appbar_icons.dart';
import '../../styles.dart';

class InventoryForm extends StatefulWidget {
  const InventoryForm({Key? key}) : super(key: key);

  @override
  State<InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<InventoryForm> {
  late final GSheetHandler _handler;
  late final Uuid _uuid;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _uuid = const Uuid();
    _handler = GSheetHandler();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final combiner = BlocProvider.of<BlocsCombiner>(context);

    return SafeArea(
      child: Scaffold(
        appBar: showAppBarWithBackBtn(context, combiner: combiner),
        body: ListView(
          children: [
            const SizedBox(
              height: outerSpacing,
            ),
            Center(
              child: Text(
                'Add Item Form'.toUpperCase(),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            const SizedBox(
              height: outerSpacing,
            ),
            const SizedBox(
              height: outerSpacing,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: outerSpacing),
              child: FormGroup(formKey: _formKey),
            ),
            const SizedBox(
              height: outerSpacing * 3,
            ),
            Center(
              child:
                  FormBtns(combiner: combiner, uuid: _uuid, handler: _handler),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
