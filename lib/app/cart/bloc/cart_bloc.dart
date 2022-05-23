import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whiteboard/app/utils/constants.dart';
import 'package:whiteboard/datakit/models/address_list_model.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';
import 'dart:math';


part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {

  CartClient service;

  CartBloc(this.service) : super(CartLoading());

  @override
  CartState get initialState => CartLoading();

  @override
  Stream<Transition<CartEvent, CartState>> transformEvents(
      Stream<CartEvent> events,
      TransitionFunction<CartEvent, CartState> transitionFn,
      ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  Stream<CartState> cartCount(CartCount event) async* {
    try {
      final result = await service.getCartContent(cartToken: event.cartToken);

      if (result == null) {
        yield CartCountFailed('Incorrect coupon.');
      } else {
        yield CartCountSuccess();
      }
    } catch (e) {
      yield CartCountFailed(e.toString());
    }
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is LoadingCart) {
      yield* fetchCart(event);
    } else if (event is CartRefresh) {
      yield CartRefreshed(
          DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999));
    } else if (event is SendOrder) {
      yield* _mapSendOrder(event);
    } else if (event is ApplyingCoupon) {
      yield* _applyCoupon(event);
    } else if (event is CartCounterRefresh) {
      yield CartCounterRefreshed(
          DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999));
    } else if (event is CartCount) {
      yield* cartCount(event);
    }
  }

  Stream<CartState> _applyCoupon(ApplyingCoupon event) async* {
    try {
      final result = await service.applyCoupon(cartToken: event.cartToken, code: event.code);

      if (result == null) {
        yield CouponFailed('Incorrect coupon.');
      } else {
        yield CouponSuccess();
      }
    } catch (e) {
      print(e);
      yield CouponFailed(e.toString());
    }
  }

  Stream<CartState> fetchCart(LoadingCart event) async* {
    try {
      final result = await service.getCartContent(cartToken: event.cartToken);

      if (result == null) {
        yield LoadCartFail('No available products here,');
      } else {
        print('Success result: ${result.items.length}');
        Constants.count = result.items.length;
        yield LoadCartSuccess(products: result.items, prices: result.prices, availablePaymentMethods: result.availablePaymentMethods);
      }
    } catch (e) {
      print(e);
      yield LoadCartFail(e.toString());
    }
  }

  Stream<CartState> _mapSendOrder(SendOrder event) async* {
    try {
      final result = await service.placeOrder(cartToken: event.cartToken);

      if (result == null) {
        yield OrderFail('Send order process failed.');
      } else {
        print('Success');
        yield SendOrderSuccess();
      }
    } catch (e) {
      print(e);
      yield OrderFail(e.toString());
    }
  }
}
