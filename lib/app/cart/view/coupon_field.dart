import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteboard/app/cart/bloc/cart_bloc.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';

class CouponField extends StatefulWidget {
  final String token;

  CouponField({required this.token});

  @override
  State<StatefulWidget> createState() {
   return CouponFieldState(token: token);
  }
}

class CouponFieldState extends State<CouponField> {
  final String token;
  final TextEditingController code = TextEditingController();
  CartClient service = CartClient();

  CouponFieldState({Key? key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
          height: 50,
          child: Stack(
            children: [
              TextFormField(
                cursorColor: whiteboard_red,
                controller: code,
                onChanged: (value) {},
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Voucher code',
                  hintStyle: TextStyle(color: whiteboard_dark_grey),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: whiteboard_dark_grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 1,
                    color: whiteboard_dark_grey,
                  )),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1, color: whiteboard_dark_grey),
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.red)),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                whiteboard_dark_grey)),
                        onPressed: () async {
                          final result = await service.applyCoupon(cartToken: token, code: code.text);
                          if(result == "1") {
                            BlocProvider.of<CartBloc>(context).add(CartRefresh());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result),backgroundColor: Colors.red,));
                          }
                        },
                        child: Text('APPLY'))),
              )
            ],
          ),
        ),
      ],
    );
  }
}
