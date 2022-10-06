part of 'cart_badge_bloc.dart';

abstract class CartBadgeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CartBadgeCountStart extends CartBadgeEvent{
  final String token;

  CartBadgeCountStart(this.token);
}
class CartBadgeRefresh extends CartBadgeEvent {}