
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserFetched extends ProfileEvent {}

class LoadProfile extends ProfileEvent {}
class LoadMyAddressList extends ProfileEvent {}
class LoadMyBillingAddressList extends ProfileEvent {}
class AddressRefresh extends ProfileEvent {}

class ProfileUpdating extends ProfileEvent{
  final String firstName;
  final String lastName;
  final String email;

  ProfileUpdating({required this.firstName,required this.lastName,required this.email});

  @override
  List<Object> get props => [firstName, lastName, email];
}


class ProfileUpdate extends ProfileEvent {
  final User user;
  final File? file;
  ProfileUpdate({required this.user, required this.file});

  @override
  List<Object> get props => [user];
}

class PasswordUpdate extends ProfileEvent {
  final String newPassword;
  final String confirmPassword;
  PasswordUpdate({required this.newPassword, required this.confirmPassword});

  @override
  List<Object> get props => [newPassword, confirmPassword];
}