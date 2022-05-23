part of 'profile_bloc.dart';


@immutable
class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}


class AddressLoaded extends ProfileState{
  final List<AddressList> addressList;

  AddressLoaded({required this.addressList});
  @override
  List<Object> get props => [addressList];
}
class ProfileUpdated extends ProfileState {
  final User user;

  ProfileUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

class PasswordUpdated extends ProfileState {}

class AddressListRefreshed extends ProfileState {
  final int time;

  AddressListRefreshed(this.time);
  @override
  List<Object> get props => [time];
  @override
  String toString() {
    return time.toString();
  }
}

class Failure extends ProfileInitial {
  final String error;

  Failure({required this.error});

}

