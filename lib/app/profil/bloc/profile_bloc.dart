import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meta/meta.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/models/user.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';
import 'package:whiteproject/network_kit/repository/user/authentication_repository.dart';
import 'dart:math';


part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  final AuthClientGraphQL clientGraphQL =  AuthClientGraphQL();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield await _mapUserFetched(state);
    } else if(event is LoadMyAddressList) {
      yield await _mapUserAddressFetched(state);
    } else if (event is AddressRefresh) {
      yield AddressListRefreshed(
          DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999));
    } else if(event is LoadMyBillingAddressList) {
      yield await _mapUserBillingAddressFetched(state);
    }
  }

  Future<ProfileState> _mapUserFetched(ProfileState state) async {
    try {
      var response = await authenticationRepository.getUserData();
      if (response != null) {
        return ProfileLoaded(user: response);
      } else {
        return Failure(error: "");
      }
    } on Exception catch (err) {
      return Failure(error: err.toString());
    }
  }

  Future<ProfileState> _mapUserAddressFetched(ProfileState state) async {
    try {
      var response = await authenticationRepository.getAddress();
      if (response != null) {
        return AddressLoaded(addressList: response);
      } else {
        return Failure(error: "");
      }
    } on Exception catch (err) {
      return Failure(error: err.toString());
    }
  }

  Future<ProfileState> _mapUserBillingAddressFetched(ProfileState state) async {
    try {
      var response = await authenticationRepository.getBillingAddress();
      if (response != null) {
        return AddressLoaded(addressList: response);
      } else {
        return Failure(error: "");
      }
    } on Exception catch (err) {
      return Failure(error: err.toString());
    }
  }
}
