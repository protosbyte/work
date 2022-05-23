import 'package:flutter/material.dart';
import 'package:whiteproject/app/utils/colors.dart';

const wb_bold_black_text_style = TextStyle(
    color: whiteproject_black,
    fontSize: 24,
    fontWeight: FontWeight.bold);

const wb_bold_black_16_text_style = TextStyle(
    color: whiteproject_black,
    fontSize: 16,
    fontWeight: FontWeight.bold);

const wb_normal_grey_text_style =  TextStyle(
    color: whiteproject_dark_grey,
    fontSize: 14,
    fontWeight: FontWeight.w300);

const wb_normal_red_text_style =  TextStyle(
    color: whiteproject_red,
    fontSize: 14,
    fontWeight: FontWeight.w300);

// big red button
ButtonStyle wbRedButtonTextStyle = ElevatedButton.styleFrom(
    primary: whiteproject_red,
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    textStyle: TextStyle(
      fontSize: 16,
    ));
