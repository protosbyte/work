part of 'cart_bloc.dart';

class CartState extends Equatable {
  CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  CartLoading() : super();
}

class LoadCartSuccess extends CartState {
  final List<Item> products;
  final Prices prices;
  final List<PaymentMethod> availablePaymentMethods;


  LoadCartSuccess({required this.products, required this.prices, required this.availablePaymentMethods});

  @override
  List<Object> get props => [products, prices, availablePaymentMethods];
}

class LoadCartFail extends CartState {
  final dynamic error;

  LoadCartFail(this.error) : super();

  @override
  List<Object> get props =>[];
}

class OrderFail extends CartState {
  final dynamic error;

  OrderFail(this.error) : super();

  @override
  List<Object> get props =>[];
}

class CouponSuccess extends CartState{}
class CartCountSuccess extends CartState{}

class CartCountFailed extends CartState{
  final dynamic error;

  CartCountFailed(this.error) : super();

  @override
  List<Object> get props =>[];
}

class CouponFailed extends CartState{
  final dynamic error;

  CouponFailed(this.error) : super();

  @override
  List<Object> get props =>[];
}

class CartRefreshed extends CartState {
  final int time;

  CartRefreshed(this.time);
  @override
  List<Object> get props => [time];
  @override
  String toString() {
    return time.toString();
  }
}

class CartCounterRefreshed extends CartState {
  final int time;

  CartCounterRefreshed(this.time);
  @override
  List<Object> get props => [time];
  @override
  String toString() {
    return time.toString();
  }
}

class SendOrderSuccess extends CartState {}
class SetShippingAddressesOnCartSuccess extends CartState {}
class SetShippingAddressesOnCartFailed extends CartState {
  final dynamic error;

  SetShippingAddressesOnCartFailed(this.error) : super();

  @override
  List<Object> get props =>[];
}