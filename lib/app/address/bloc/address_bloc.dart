import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/src/transformers/backpressure/throttle.dart';
import 'package:whiteproject/network_kit/repository/address/address_client.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressClient service;

  AddressBloc(this.service) : super(Loading());

  @override
  AddressState get initialState => Loading();

  @override
  Stream<Transition<AddressEvent, AddressState>> transformEvents(
    Stream<AddressEvent> events,
    TransitionFunction<AddressEvent, AddressState> transitionFn,
  ) {
    return super.transformEvents(
      events.throttleTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    if (event is CreateCustomerAddress) {
      yield* _mapCreateAddress(event);
    } else if (event is DeleteAddress) {
      yield* _mapDeleteAddress(event);
    }
  }

  Stream<AddressState> _mapCreateAddress(CreateCustomerAddress event) async* {
    try {
      final result = await service.createAddress(
          id: event.id,
          region: event.region,
          regionCode: event.regionCode,
          countryCode: event.countryCode,
          streetName: event.streetName,
          postCode: event.postCode,
          city: event.city,
          phone: event.phone,
          vatID: event.vatID,
          company: event.company,
          defaultShipping: event.defaultShipping,
          defaultBilling: event.defaultBilling);

      if (result != "1") {
        yield LoadDataFail('No available products here,');
      } else {
        yield LoadAddressSuccess();
      }
    } catch (e) {
      print(e);
      yield LoadDataFail(e.toString());
    }
  }

  Stream<AddressState> _mapDeleteAddress(DeleteAddress event) async* {
    try {
      final result = await service.deleteAddress(id: event.id);

      if (result == -1) {
        yield AddressDeleteFailed('No available products here,');
      } else {
        yield AddressDeleteSuccess();
      }
    } catch (e) {
      print(e);
      yield AddressDeleteFailed(e.toString());
    }
  }
}
