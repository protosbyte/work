import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/src/transformers/backpressure/throttle.dart';
import 'package:winebox/datakit/repository/cart/cart_client.dart';
import 'dart:math';

part 'cart_badge_event.dart';
part 'cart_badge_state.dart';

class CartBadgeBloc extends Bloc<CartBadgeEvent, CartBadgeState> {

  CartClient service;

  CartBadgeBloc(this.service) : super(CartBadgeLoading());

  @override
  CartBadgeState get initialState => CartBadgeLoading();

  @override
  Stream<Transition<CartBadgeEvent, CartBadgeState>> transformEvents(
      Stream<CartBadgeEvent> events,
      TransitionFunction<CartBadgeEvent, CartBadgeState> transitionFn,) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<CartBadgeState> mapEventToState(CartBadgeEvent event) async* {
    if (event is CartBadgeCountStart) {
      yield* count(event);
    } else if (event is CartBadgeRefresh) {
      yield CartBadgeRefreshed(
          DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999));
    }
  }

  Stream<CartBadgeState> count(CartBadgeCountStart event) async* {
    print('called');
    try {
      final result = await service.getCartContent(cartToken: event.token);
      yield CartCountSuccess(count: result.items.length);

    } catch (e) {
      yield CartCountFailed(e.toString());
    }
  }
}