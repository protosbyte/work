import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whiteproject/app/profil/bloc/profile_bloc.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/error_widget.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/very_good_infinite_list.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/repository/address/address_client.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';
import 'package:whiteproject/locator.dart';
import '../../../../navigation_service.dart';
import 'add_address_screen.dart';
import 'address_edit.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late MyProgress pr;
  final GlobalKey<InfiniteListState> infiniteListStateKey = GlobalKey();
  AuthClientGraphQL client = AuthClientGraphQL();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadMyAddressList()),
      child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is AddressListRefreshed) {
              infiniteListStateKey.currentState?.refresh();
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (context, state) => !(state is AddressListRefreshed),
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<ProfileBloc>(context).add(
                      AddressRefresh(),
                    );
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InfiniteList<AddressList>(
                          key: infiniteListStateKey,
                          padding: const EdgeInsets.only(bottom: 0),
                          itemLoader: _itemLoader,
                          isGrid: false,
                          builder: InfiniteListBuilder<AddressList>(
                            empty: (context) => Container(),
                            loading: (context) => MyLoadingWidget(),
                            success: (context, item) =>
                                addressListTile(context, item),
                            error: (context, retry, error) {
                              return MyErrorWidget(error: error, retry: retry);
                            },
                          ),
                          bottomLoader: (context) => SizedBox(),
                          errorLoader: (context, retry, error) =>
                              MyErrorLoader(retry: retry),
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: () async {
                            pr.show(context, context);
                            final status = await Permission.locationWhenInUse.request();
                            print('Status: ${status}');
                            if (status.isPermanentlyDenied ||
                                status.isDenied) {
                              pr.hide(context);
                              openAppSettings();
                            } else {
                              pr.show(context, context);
                              Position currentLocation =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.medium);
                              pr.hide(context);
                              locator<NavigationService>()
                                  .push(AddAddressScreen.route(currentLocation))
                                  ?.then((shouldRefresh) {
                                if (shouldRefresh ?? false) {
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    AddressRefresh(),
                                  );
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 1, left: 20, right: 20, bottom: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: whiteproject_red,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                    child: Text(
                                  'Add new address',
                                  style: TextStyle(
                                      fontSize: 16, color: whiteproject_red),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  Future getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  Future<List<AddressList>?> _itemLoader(int limit, {int start = 1}) async {
    var result = await client.getMyAddresses();
    return result;
  }

  Widget addressListTile(BuildContext context, AddressList address) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    AddressClient service = AddressClient();
    return GestureDetector(
      onTap: () async {
        pr.show(context, context);
        await Future.delayed(Duration(seconds: 1));
        updateFunction(context, address);
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 7),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.street.first,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(address.city, style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Icon(
                Icons.edit,
                color: whiteproject_red,
              ),
              IconButton(
                onPressed: () async {
                 deleteDialog(context, service, address);
                },
                icon: Icon(Icons.delete, color: whiteproject_red),
              )
            ],
          )),
    );
  }

  updateFunction(BuildContext context, AddressList address) async {
    List<Location> locations =
        await locationFromAddress("${address.street}, ${address.city}");
    Position myPosition = Position(
        longitude: locations.first.longitude,
        latitude: locations.first.latitude,
        timestamp: locations.first.timestamp,
        accuracy: 100.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    pr.hide(context);
    locator<NavigationService>()
        .push(AddressEdit.route(myPosition, address))
        ?.then((shouldRefresh) {
      if (shouldRefresh ?? false) {
        BlocProvider.of<ProfileBloc>(context).add(
          AddressRefresh(),
        );
      }
    });
  }
}

deleteDialog(BuildContext context, service, AddressList address) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        titleText: 'Are you sure you want to delete this address?',
        contentText: '',
        onPositiveClick: () async {
          var result = await service.deleteAddress(id: address.id);
          if (result != "1") {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(result)));
          } else {
            BlocProvider.of<ProfileBloc>(context).add(
              AddressRefresh(),
            );
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Address deleted'),
              backgroundColor: Colors.green,
            ));
          }
          Navigator.of(context).pop();
        },
        onNegativeClick: () {
          Navigator.of(context).pop();
        },
        positiveTextStyle: TextStyle(color: whiteproject_red),
        positiveText: 'Yes',
        negativeText: 'No',
      );
    },
    animationType: DialogTransitionType.rotate3D,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 500),
  );
}
