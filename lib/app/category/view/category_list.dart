import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteboard/app/category/bloc/category_bloc.dart';
import 'package:whiteboard/app/category/view/card/category_card.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';
import 'package:whiteboard/datakit/repository/category/category_client.dart';
import 'category_page_slider.dart';


class CategoryGridList extends StatefulWidget{

  static Route route() {
    return MaterialPageRoute(builder: (_) => CategoryGridList());
  }

  @override
  State<StatefulWidget> createState() {
    return CategoryGridListState();
  }
}

class CategoryGridListState extends State<CategoryGridList> {
  CartClient cartClient = CartClient();

  final CategoryClient categoryClient = CategoryClient();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryBloc(categoryClient)
        ..add(CategoryFetched()),
      child: _buildCategoryContent(context),
    );
  }

  Widget _buildCategoryContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      alignment: Alignment.topLeft,
      child: _createGridList(context),
    );
  }

  Widget _createGridList(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        CategoryPageSlider(),
        BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state is Loading) {
            return Center(child: Container(width: 150,child: LinearProgressIndicator(color: whiteboard_red,backgroundColor: Colors.grey,)));
          } else if (state is LoadDataFail) {
            return Text(state.error);
          } else if (state is LoadDataSuccess){
            return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait? 2:4),
              itemCount: state.categories.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  child: CategoryCard(category: state.categories[index]),
                  onTap: () {},
                );
              },
            );
          } else {
            return Center(child: Text('Error occurred'),);
          }
        }),
      ],
    );
  }
}
