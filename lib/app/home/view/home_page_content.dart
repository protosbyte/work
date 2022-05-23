import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:whiteproject/app/category/view/category_list.dart';

class HomePageContent extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageContentState();
  }
}
class HomePageContentState extends State<HomePageContent> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            new Container(
                child: CategoryGridList()),
          ],
        ),
      ),
    );
  }
}