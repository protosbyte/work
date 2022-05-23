import 'package:flutter/material.dart';

class CategoryCardTitle extends StatelessWidget {
  const CategoryCardTitle({Key? key, required this.categoryTitle, required this.productCount}) : super(key: key);

 final String categoryTitle;
 final String productCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
      child: Row(
        children: [
          Expanded(
              child: Text(
                categoryTitle + ' ($productCount)',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
