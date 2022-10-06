import 'package:flutter/material.dart';
import 'package:winebox/app/utils/colors.dart';

class CustomTextFormField {

  TextFormField getCustomEditTextArea(
      {String labelValue = "",
      String hintValue = "",
      required bool validation,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      required TextStyle textStyle,
      required String validationErrorMsg}) {
    return TextFormField(
      keyboardType: keyboardType,
      style: textStyle,
      obscureText: true,
      enableSuggestions: false,
      controller: controller,
      validator: null,
      decoration: InputDecoration(
          focusedBorder:  OutlineInputBorder(
              borderSide:  BorderSide(color: winebox_red, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          labelText: labelValue,
          hintText: hintValue,
          labelStyle: textStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
      ),
    );
  }
}

// return TextFormField(
//     keyboardType: TextInputType.visiblePassword,
//     obscureText: true,
//     enableSuggestions: false,
//     autocorrect: false,
//     decoration: const InputDecoration(
//       focusedBorder: const OutlineInputBorder(
//           borderSide: const BorderSide(color: winebox_red, width: 1.0),
//           borderRadius: BorderRadius.all(Radius.circular(5))),
//       border: const OutlineInputBorder(),
//       hintText: hintText,
//       // labelText:  StringsWinebox.login_email,
//       // prefixText: '\$',
//       // suffixText: 'USD',
//       // suffixStyle: TextStyle(color: Colors.green)),
//     ));