import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winebox/app/cart/view/my_cart.dart';
import 'package:winebox/app/mini_cart/bloc/cart_badge_bloc.dart';
import 'package:winebox/app/navigation_service.dart';
import 'package:winebox/app/utils/my_shared_preferences.dart';
import 'package:winebox/datakit/repository/cart/cart_client.dart';

import '../../../locator.dart';

class CartBadge extends StatefulWidget {
  CartBadge({Key? key}) : super(key: key);

  @override
  CartBadgeWidgetState createState() => CartBadgeWidgetState();
}

class CartBadgeWidgetState extends State<CartBadge> {
  CartClient client = CartClient();

  refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MySharedPreferences.instance.getStringValue('userCartToken'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
         return FutureBuilder(
           future: getData(snapshot.data),
           builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotTwo) {
             if(snapshotTwo.hasData) {
               return GestureDetector(
                 onTap: () async{
                   if(snapshotTwo.data == 0) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The cart is empty')));
                   } else {
                     locator<NavigationService>()
                         .push(MyCart.route(snapshot.data))?.then((
                         shouldRefresh) {
                       if (shouldRefresh ?? false) {
                         refresh();
                       }
                     });
                   }
                 },
                 child: Container(
                   margin: EdgeInsets.only(right: 10),
                   alignment: Alignment.center,
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                       image: DecorationImage(
                           image: AssetImage('images/cart_icon.png'), fit: BoxFit.fitWidth
                       )
                   ),
                   child: Padding(
                     padding: EdgeInsets.only(top: 5),
                     child: Text(snapshotTwo.data != 0 ?snapshotTwo.data.toString(): '', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),),
                   ),
                 ),
               );
             } else {
               return Container(
                 margin: EdgeInsets.only(right: 10),
                 alignment: Alignment.center,
                 width: 30,
                 height: 30,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage('images/cart_icon.png'), fit: BoxFit.fitWidth
                     )
                 ),
                 child: Padding(
                   padding: EdgeInsets.only(top: 5),
                   child: Text('', style: TextStyle(color: Colors.white),),
                 ),
               );
             }
           },
         );
        } else {
          return Text('no token');
        }
      },
    );
  }
  Future<int> getData(String cartToken) async {
    print('Token: $cartToken');
    var res = await client.getCartContent(cartToken: cartToken);
    return res.items.length;
  }

}
