import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteboard/app/cart/bloc/cart_bloc.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/app/widgets/my_progress.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';

import 'my_subtitle.dart';

class ShippingMethodTile extends StatefulWidget {

  String cartToken;
  List<AvailableShippingMethod> shippingMethods;

  ShippingMethodTile({Key? key, required this.cartToken, required this.shippingMethods}) : super(key: key);

  @override
  _ShippingMethodTileState createState() => _ShippingMethodTileState(cartToken: cartToken, shippingMethods: shippingMethods);
}

class _ShippingMethodTileState extends State<ShippingMethodTile> {
  String cartToken;
  List<AvailableShippingMethod> shippingMethods;
  CartClient service = CartClient();
  late MyProgress pr;

  _ShippingMethodTileState({required this.cartToken,required this.shippingMethods});

  @override
  Widget build(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return Column(
      children: [
        MySubTitle(
          text: 'Shipping Methods',
          fontSize: 16,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
            children: shippingMethods
                .map((item) => GestureDetector(
              onTap: () async {
                pr.show(context, context);
                var res = await service
                    .setShippingMethode(
                    cartToken:
                   cartToken,
                    carrierCode:
                    item.carrierCode,
                    methodeCode:
                    item.methodCode);
                if(res == -1) {
                  pr.hide(context);
                } else {
                  pr.hide(context);
                  if (shippingMethods
                      .isNotEmpty) {
                    setState(() {
                      shippingMethods.first
                          .isChecked = false;
                      shippingMethods.clear();
                      item.isChecked =
                      !item.isChecked;
                      BlocProvider.of<CartBloc>(
                          context)
                          .add(CartRefresh());
                      shippingMethods.add(item);
                    });
                    pr.hide(context);
                  } else {
                    shippingMethods.clear();
                    setState(() =>
                    item.isChecked =
                    !item.isChecked);
                    BlocProvider.of<CartBloc>(
                        context)
                        .add(CartRefresh());
                    shippingMethods.add(item);
                    pr.hide(context);
                  }
                }
              },
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(
                          bottom: 7,
                          left: 20,
                          right: 20,),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          color: Colors.white,
                          border: Border.all(
                              color:
                              whiteboard_light_grey)),
                      child: Row(
                        children: [
                          Icon(
                            item.isChecked
                                ? Icons
                                .check_circle
                                : Icons
                                .panorama_fish_eye,
                            size: 16,
                            color: item
                                .isChecked
                                ? whiteboard_red
                                : whiteboard_light_grey,
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                              child: Text(
                                item.methodTitle +
                                    ',' +
                                    item
                                        .carrierTitle +
                                    ' ' +
                                    item.amount
                                        .value
                                        .toString() +
                                    ' ' +
                                    item.amount
                                        .currency,
                                style: TextStyle(
                                    fontSize: 16),
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ))
                        ],
                      )),
                ],
              ),
            ))
                .toList())
      ],
    );
  }
}
