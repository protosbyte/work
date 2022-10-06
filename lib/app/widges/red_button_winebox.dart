import 'package:flutter/material.dart';
import 'package:winebox/app/utils/colors.dart';

class RedButtonWine extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const RedButtonWine(this.onPressed, this.label);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:   RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: winebox_red)
          ),
        minimumSize: Size(double.infinity,30),
          primary: winebox_red,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: TextStyle(
            fontSize: 16,
          )),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const WhiteButton(this.onPressed, this.label);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:   RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: winebox_red)
    ),
          minimumSize: Size(double.infinity,30),
          primary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: TextStyle(
            fontSize: 16,
          )),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, color: winebox_red),
      ),
    );
  }
}
