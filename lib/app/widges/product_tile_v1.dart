import 'package:flutter/material.dart';

class ProductTileV1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'EUR/USD',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text('FOREX', style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        onPressed: () {
                          print('On Pressed');
                        },
                        icon: Icon(Icons.add),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
