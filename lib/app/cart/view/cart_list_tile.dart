import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteboard/app/cart/bloc/cart_bloc.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/app/utils/styles.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';

class CartListTile extends StatelessWidget {

  final CartClient cartClient = CartClient();
  final String cartToken;
  CartListTile({required this.cartToken,required this.product, Key? key}) : super(key: key);

  final Item product;
  @override
  Widget build(BuildContext context) {
    return createCartList(context, product);
  }

  Widget createCartList(BuildContext context, var product) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      product.quantity < 2 ? Icons.delete : Icons.remove,
                      color: whiteboard_dark_grey,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      if (product.quantity < 2) {
                        bool res = await cartClient.removeProductFromCart(
                            token: cartToken, productID: int.parse(product.id));
                        if (res) {
                          BlocProvider.of<CartBloc>(context).add(CartRefresh());
                        } else {
                          ///item remove failed
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error occorred'),
                          ));
                        }
                      } else {
                        bool res = await cartClient.updateCartItem(
                            token: cartToken,
                            productID: product.uid,
                            quantity: product.quantity - 1);
                        if (res) {
                          BlocProvider.of<CartBloc>(context).add(CartRefresh());
                        } else {
                          ///remove failed
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error occorred'),
                          ));
                        }
                      }
                    },
                  ),
                  Text(product.quantity.toString()),
                  IconButton(
                    icon: Icon(Icons.add, color: whiteboard_dark_grey, size: 20),
                    onPressed: () async {
                      bool res = await cartClient.updateCartItem(
                          token: cartToken,
                          productID: product.uid,
                          quantity: product.quantity + 1);
                      if (res) {
                        BlocProvider.of<CartBloc>(context).add(CartRefresh());
                      } else {
                        ///remove failed
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error occorred'),
                        ));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.product.name, style: TextStyle(color: whiteboard_black_2, fontSize: 16)),
                Text(
                    product.prices.price.value.toString() +
                        ' ' +
                        product.prices.price.currency,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: whiteboard_red))
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: Icon(Icons.chevron_right, color: whiteboard_grey_4,),
                  margin: EdgeInsets.only(right: 1),
                )),
          ),
        ],
      ),
    );
  }
}
