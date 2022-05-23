part of 'address_bloc.dart';

class AddressState extends Equatable {
  AddressState();

  @override
  List<Object> get props => [];
}
class Loading extends AddressState {
  Loading() : super();
}


class LoadAddressSuccess extends AddressState {
  @override
  List<Object> get props => [];
}
class AddressDeleteSuccess extends AddressState {
  @override
  List<Object> get props => [];
}

class LoadDataFail extends AddressState {
  final dynamic error;

  LoadDataFail(this.error) : super();

  @override
  List<Object> get props =>[];
}

class AddressDeleteFailed extends AddressState {
  final dynamic error;

  AddressDeleteFailed(this.error) : super();

  @override
  List<Object> get props =>[];
}

class AddressSavedSuccess extends AddressState {}

