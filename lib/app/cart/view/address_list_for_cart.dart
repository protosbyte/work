import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whiteboard/app/address/view/add_address_screen.dart';
import 'package:whiteboard/app/cart/bloc/cart_bloc.dart';
import 'package:whiteboard/app/cart/view/shipping_method_tile.dart';
import 'package:whiteboard/app/profil/bloc/profile_bloc.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/app/widgets/error_widget.dart';
import 'package:whiteboard/app/widgets/my_progress.dart';
import 'package:whiteboard/app/widgets/very_good_infinite_list.dart';
import 'package:whiteboard/datakit/models/address_list_model.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';
import 'package:whiteboard/datakit/repository/user/auth_client_graphql.dart';

import '../../../locator.dart';
import '../../../../navigation_service.dart';
import 'my_subtitle.dart';

class AddressListForCartWidget extends StatefulWidget {
  final String cartToken;
  List<AddressList> preSelectAddresses = [];

  AddressListForCartWidget(
      {Key? key, required this.cartToken, required this.preSelectAddresses})
      : super(key: key);

  @override
  AddressListForCartWidgetState createState() =>
      AddressListForCartWidgetState();
}

class AddressListForCartWidgetState extends State<AddressListForCartWidget> {
  late MyProgress pr;
  final GlobalKey<InfiniteListState> infiniteListStateKey = GlobalKey();
  AuthClientGraphQL client = AuthClientGraphQL();
  CartClient service = CartClient();
  List<AddressList> selectedAddress = [];
  List<AvailableShippingMethod> shippingMethods = [];
  List<AvailableShippingMethod> selectedShippingMethods = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ProfileBloc>(
        create: (BuildContext context) =>
            ProfileBloc()..add(LoadMyAddressList()),
      ),
      BlocProvider<CartBloc>(
        create: (BuildContext context) => CartBloc(service),
      ),
    ], child: content(context));
  }

  Widget content(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return BlocListener<ProfileBloc, ProfileState>(
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
                      GestureDetector(
                        onTap: () async {
                          Position currentLocation =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.medium);
                          locator<NavigationService>()
                              .push(AddAddressScreen.route(currentLocation))
                              ?.then((shouldRefresh) {
                            if (shouldRefresh ?? false) {
                              BlocProvider.of<ProfileBloc>(context).add(
                                AddressRefresh(),
                              );
                            }
                          });
                        },
                        child: Container(
                            margin:
                                EdgeInsets.only(bottom: 0, left: 20, right: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: vanilla,
                                border: Border.all(color: whiteboard_light_grey)),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: whiteboard_red,
                                  ),
                                  onPressed: () {},
                                ),
                                Expanded(
                                    child: Text(
                                  'Add new address',
                                  style: TextStyle(
                                      fontSize: 16, color: whiteboard_red),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            )),
                      ),
                      shippingMethods.isNotEmpty
                          ? ShippingMethodTile(
                              cartToken: widget.cartToken,
                              shippingMethods: shippingMethods)
                          : SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                ),
              );
            }));
  }

  Future<List<AddressList>?> _itemLoader(int limit, {int start = 1}) async {
    var result = await client.getMyAddresses();
    return result;
  }

  Widget addressListTile(BuildContext context, AddressList address) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          pr.show(context, context);
          var res = await service.setShippingAddressesOnCart(
              cartToken: widget.cartToken, address: address, context: context);
          if (res.isEmpty) {
            pr.hide(context);
          } else {
            var billingAddressResult = await service.setBillingAddress(
                cartToken: widget.cartToken, address: address);
            if (billingAddressResult == 1) {
              if (selectedAddress.isNotEmpty) {
                setState(() {
                  selectedAddress.first.isChecked = false;
                  selectedAddress.clear();
                  shippingMethods.clear();
                  address.isChecked = !address.isChecked;
                  shippingMethods.addAll(res.first.availableShippingMethods);
                  BlocProvider.of<CartBloc>(context).add(CartRefresh());
                  selectedAddress.add(address);
                });
                pr.hide(context);
              } else {
                selectedAddress.clear();
                shippingMethods.clear();
                setState(() => address.isChecked = !address.isChecked);
                selectedAddress.add(address);
                shippingMethods.addAll(res.first.availableShippingMethods);
                BlocProvider.of<CartBloc>(context).add(CartRefresh());
                pr.hide(context);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to set billing address')));
            }
          }
        },
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 7, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    border: Border.all(color: whiteboard_light_grey)),
                child: Row(
                  children: [
                    Icon(
                      address.isChecked
                          ? Icons.check_circle
                          : Icons.panorama_fish_eye,
                      size: 16,
                      color:
                          address.isChecked ? whiteboard_red : whiteboard_light_grey,
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                        child: Text(
                      address.street.first + ", " + address.city,
                      style: TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
