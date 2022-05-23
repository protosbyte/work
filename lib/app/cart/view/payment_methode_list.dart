import 'package:flutter/material.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';

class PaymentMethodeTile extends StatefulWidget {

  final String cartToken;

  final List<PaymentMethod> availablePaymentMethods;

  PaymentMethodeTile({Key? key,required this.cartToken, required this.availablePaymentMethods})
      : super(key: key);

  @override
  _PaymentMethodeTileState createState() =>
      _PaymentMethodeTileState(
          availablePaymentMethods: availablePaymentMethods);
}

class _PaymentMethodeTileState extends State<PaymentMethodeTile> {
  CartClient service = CartClient();
  final List<PaymentMethod> availablePaymentMethods;
  List<PaymentMethod> selectedPM = [];
  _PaymentMethodeTileState({required this.availablePaymentMethods});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: availablePaymentMethods
            .map((item) =>
            GestureDetector(
              onTap: () async {
               var res = await service.setPaymentMethod(cartToken: widget.cartToken, code: item.code);
               if(res != 1) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This payment methode cannot be set.')));
               } else if (res == 1){
                 if(selectedPM.isNotEmpty){
                   setState(() {
                     selectedPM.first.isChecked = false;
                     selectedPM.clear();
                     item.isChecked = !item.isChecked;
                     selectedPM.add(item);
                   });
                 } else {
                   selectedPM.clear();
                   setState(() => item.isChecked = !item.isChecked);
                   selectedPM.add(item);
                 }
               }
              },
              child: Container(
                  margin:
                  EdgeInsets.only(left: 20, right: 20, top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: whiteboard_light_grey)
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            var res = await service.setPaymentMethod(cartToken: widget.cartToken, code: item.code);
                            if(res != 1) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This payment methode cannot be set.')));
                            } else if (res == 1){
                              if(selectedPM.isNotEmpty){
                                setState(() {
                                  selectedPM.first.isChecked = false;
                                  selectedPM.clear();
                                  item.isChecked = !item.isChecked;
                                  selectedPM.add(item);
                                });
                              } else {
                                selectedPM.clear();
                                setState(() => item.isChecked = !item.isChecked);
                                selectedPM.add(item);
                              }
                            }
                          },
                        icon: Icon(
                          item.isChecked ? Icons.check_circle : Icons.panorama_fish_eye,
                          size: 16,
                          color: item.isChecked ? whiteboard_red : whiteboard_light_grey,
                        ),),
                      Expanded(child: Text(item.title, style: TextStyle(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ],
                  )),
            ))
            .toList());
  }
}
