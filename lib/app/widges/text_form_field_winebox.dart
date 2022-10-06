import 'package:flutter/material.dart';
import 'package:winebox/app/utils/colors.dart';

class TextFormFieldWine extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final String initialValue;
  final TextEditingController controller;

  TextFormFieldWine(
       this.textInputType, this.hintText, this.initialValue, this.controller);

  @override
  _TextFormFieldWineState createState() => _TextFormFieldWineState(controller);
}

class _TextFormFieldWineState extends State<TextFormFieldWine> {
  TextEditingController _controller;

  _TextFormFieldWineState(this._controller);

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.initialValue;

    return TextFormField(
        controller: _controller,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: winebox_red, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
        ));
  }
}
