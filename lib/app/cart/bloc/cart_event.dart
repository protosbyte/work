
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingCart extends CartEvent{
  final String cartToken;

  LoadingCart({required this.cartToken});

  @override
  List<Object> get props => [cartToken];
}

class CartCount extends CartEvent{
  final String cartToken;

  CartCount({required this.cartToken});

  @override
  List<Object> get props => [cartToken];
}

class ApplyingCoupon extends CartEvent{
  final String cartToken;
  final String code;

  ApplyingCoupon({required this.cartToken, required this.code});

  @override
  List<Object> get props => [cartToken, code];
}

class CartRefresh extends CartEvent {}
class CartCounterRefresh extends CartEvent {}

class CartFetched extends CartEvent {}

class SetShippingAddressesOnCart extends CartEvent {
  final String cartToken;
  final AddressList address;

  SetShippingAddressesOnCart({required this.cartToken, required this.address});

  @override
  List<Object> get props => [cartToken, address];
}

class SendOrder extends CartEvent {
  final String cartToken;

  SendOrder({required this.cartToken});

  @override
  List<Object> get props => [cartToken];
}

