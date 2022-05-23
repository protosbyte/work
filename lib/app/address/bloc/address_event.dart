part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateCustomerAddress extends AddressEvent {
 final String region;
 final int id;
  final String regionCode;
  final String countryCode;
  final String streetName;
  final String postCode;
  final String city;
  final String phone;
  final String vatID;
  final String company;
  final bool defaultShipping;
  final bool defaultBilling;

  CreateCustomerAddress(
      {required this.id,
        required this.region,
      required this.regionCode,
      required this.countryCode,
      required this.streetName,
      required this.postCode,
      required this.vatID,
        required this.company,
      required this.phone,
      required this.city, required this.defaultBilling, required this.defaultShipping});
}

class LoadingAddressList extends AddressEvent {
  @override
  List<Object> get props => [];
}

class DeleteAddress extends AddressEvent {
  final int id;

  DeleteAddress(this.id);

  @override
  List<Object> get props => [id];
}


class AddressFetched extends AddressEvent {}
