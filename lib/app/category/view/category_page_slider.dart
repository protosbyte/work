import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class CategoryPageSlider extends StatefulWidget {
  const CategoryPageSlider({Key? key}) : super(key: key);

  @override
  _CategoryPageSliderState createState() => _CategoryPageSliderState();
}

class _CategoryPageSliderState extends State<CategoryPageSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 15, bottom: 15, left: 7, right: 7),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: ImageSlideshow(
        width: double.infinity,
        initialPage: 0,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'images/banner1.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'images/banner2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ],
        onPageChanged: (value) => print("Page changed $value"),
        // autoPlayInterval: 3000,
      ),
    );
  }
}
