import 'package:flutter/material.dart';
import 'package:whiteboard/app/category/view/card/category_image.dart';
import 'package:whiteboard/app/category/view/card/category_title.dart';
import 'package:whiteboard/app/products/view/product_list.dart';
import 'package:whiteboard/datakit/models/category.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';


class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  State<StatefulWidget> createState() {
    return CategoryCardState(category: category);
  }
}
class CategoryCardState extends State<CategoryCard> {
  final Category category;
  CartClient cartClient = CartClient();

  CategoryCardState({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(category.product_count == 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No available products')));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductList(category)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3)),
              ]),
          child: Column(
            children: [
              CategoryImage(imageUrl: category.image),
              CategoryCardTitle(categoryTitle: category.name, productCount: category.product_count.toString(),)
            ],
          ),
        ),
      ),
    );
  }
}
