import 'package:flutter/material.dart';

class CheckoutListTile extends StatelessWidget {
 final String title;
 final String value;

 CheckoutListTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return _checkoutListTile(title, value);
  }
}

Widget _checkoutListTile(String title, String value){
  return Container(
    child: Row(
      children: [
        Row(
          children: [
            Icon(Icons.delete_rounded),
            SizedBox(width: 10),
            Icon(Icons.add)
          ],
        ),
        SizedBox(height: 10,),
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title),
            Text(value)
          ],
        )
      ],
    ),
  );
}
