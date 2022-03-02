import 'package:purchases_flutter/models/product_wrapper.dart';

import '../constant/base_controller.dart';

abstract class SelectedSubscriptionBlocInterface {
  void selectSubscription(Product product);

  void clear();
}

class SelectedSubscriptionBloc extends BaseStreamController<Product?>
    implements BaseInterface<Product?>, SelectedSubscriptionBlocInterface {
  SelectedSubscriptionBloc({required state}) : super(state: state);

  @override
  void dispose() {
    subject.close();
  }

  @override
  Stream<Product?> get stream => subject.stream;

  @override
  void selectSubscription(Product product) {
    state = product;
  }

  @override
  void clear() {
    state = null;
  }
}
