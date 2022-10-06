import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:winebox/app/mini_cart/view/cart_badge_widget.dart';
import 'package:winebox/datakit/repository/cart/cart_client.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final double elevation;
  final VoidCallback? onTap;
  final Widget drawerIcon;
  final Widget backIcon;
  final bool showCart;
  final bool drawer;
  final Widget cartWidget;

  final CustomAppBarState appBarState;

  CustomAppBar({required this.title,
    required this.elevation,
    required this.backIcon,
    required this.drawerIcon,
    required this.showCart,
    required this.drawer,
    required this.cartWidget,
    required this.onTap})
      : preferredSize = Size.fromHeight(60.0),
        appBarState = CustomAppBarState(
            title,
            showCart,
            drawer,
            onTap,
            backIcon,
            drawerIcon,
          cartWidget
           ),
        super();

  @override
  CustomAppBarState createState() => appBarState;

  void close() {
    appBarState.close();
  }
}

class CustomAppBarState extends State<CustomAppBar> {
  final String title;
  bool showCart = true;
  bool drawer = true;
  final VoidCallback? onTap;
  final Widget drawerIcon;
  final Widget backIcon;
  final Widget cartWidget;
  final StreamController _streamController = StreamController();
  CartClient client = CartClient();

  static CustomAppBarState? of(BuildContext context) =>
      context.findAncestorStateOfType<CustomAppBarState>();

  CustomAppBarState(this.title, this.showCart, this.drawer, this.onTap,
      this.backIcon, this.drawerIcon, this.cartWidget);

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  void initState() {
    super.initState();
  }

  void close() {
    if (context != null) FocusScope.of(context).unfocus();
  }

  GlobalKey<CartBadgeWidgetState> _myKey = GlobalKey();

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      leading: drawer ? drawerIcon : backIcon,
      backgroundColor: Colors.white,
      title: title == ''
          ? ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 50, maxWidth: 200),
          child: Image.asset("images/logo_winebox.png"))
          : Text(
        title,
        style:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      elevation: 1,
      actions: <Widget>[
        showCart
            ? cartWidget
            : SizedBox(
          height: 0,
        ),
      ],
      titleSpacing: 0,
      automaticallyImplyLeading: true,
    );
  }
}
