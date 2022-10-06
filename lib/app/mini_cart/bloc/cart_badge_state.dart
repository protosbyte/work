part of 'cart_badge_bloc.dart';

class CartBadgeState extends Equatable {
  CartBadgeState();

  @override
  List<Object> get props => [];
}

class CartBadgeLoading extends CartBadgeState {
  CartBadgeLoading() : super();
}

class CartCountFailed extends CartBadgeState{
  final dynamic error;

  CartCountFailed(this.error) : super();

  @override
  List<Object> get props =>[];
}

class CartCountSuccess extends CartBadgeState{
  final int count;

  CartCountSuccess({required this.count});
}

class CartBadgeRefreshed extends CartBadgeState {
  final int time;

  CartBadgeRefreshed(this.time);
  @override
  List<Object> get props => [time];
  @override
  String toString() {
    return time.toString();
  }
}
