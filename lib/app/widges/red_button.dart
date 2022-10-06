import 'package:flutter/material.dart';
import 'package:winebox/app/utils/styles.dart';

class RedButton extends StatelessWidget {

  final String text;
  final VoidCallback onPress;

  RedButton({Key? key, required this.text, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: wbRedButtonTextStyle,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
