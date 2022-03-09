import 'package:purchases_flutter/purchases_flutter.dart';

import '../../database/in_app_purchase/purchase_api.dart';
import '../constant/base_controller.dart';

abstract class SubStatusBlocInterface {
  void getStatus(bool val);

  void changeStatus();
}

class SubStatusBloc extends BaseStreamController<bool>
    implements BaseInterface<bool>, SubStatusBlocInterface {
  SubStatusBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<bool> get stream => subject.stream;

  @override
  void getStatus(bool val) {
    state = val;
  }

  @override
  Future<void> changeStatus() async {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();

    if (purchaserInfo.entitlements.all[entitlementID] != null &&
        purchaserInfo.entitlements.all[entitlementID]!.isActive) {
      state = true;
    } else {
      state = false;
    }
  }
}
