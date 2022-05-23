import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whiteproject/app/address/view/address_list.dart';
import 'package:whiteproject/app/auth/bloc/authentication_bloc.dart';
import 'package:whiteproject/app/billing/view/billing_address_list.dart';
import 'package:whiteproject/app/contact/view/contact_us.dart';
import 'package:whiteproject/app/home/view/home_page_content.dart';
import 'package:whiteproject/app/mini_cart/view/cart_badge_widget.dart';
import 'package:whiteproject/app/orders/view/order_screen.dart';
import 'package:whiteproject/app/profil/view/profile_screen.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/utils/constants.dart';
import 'package:whiteproject/app/utils/my_shared_preferences.dart';
import 'package:whiteproject/app/utils/strings.dart';
import 'package:whiteproject/app/widgets/my_appbar.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/network_kit/repository/cart/cart_client.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';

class DrawerItem {
  String title;
  String icon;

  DrawerItem(this.title, this.icon);
}

StreamController<int> streamController = StreamController<int>();


class HomePage extends StatefulWidget {
  static Route route() {
    return routeWith();
  }

  static Route routeWith() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  final drawerItems = [
    new DrawerItem(Stringswhiteproject.home, 'images/hamburger_icon.png'),
    new DrawerItem(Stringswhiteproject.orders, 'images/orders.png'),
    new DrawerItem(Stringswhiteproject.profile, 'images/profile.png'),
    // new DrawerItem(Stringswhiteproject.billing_info, 'images/billing_info.png'),
    new DrawerItem(Stringswhiteproject.addresses, 'images/addresses_icon.png'),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  late MyProgress pr;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CartClient cartClient = CartClient();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static HomePageState? of(BuildContext context) => context.findAncestorStateOfType<HomePageState>();

  _getDrawerItemWidget(int pos) {
    Widget widgetToShow;
    switch (pos) {
      case 0:
        widgetToShow = HomePageContent();
        break;
      case 1:
        widgetToShow = OrderScreen();
        break;
      case 2:
        widgetToShow = ProfileScreen();
        break;
      // case 3:
      //   widgetToShow = BillingScreen();
      //   break;
      case 3:
        widgetToShow = AddressesScreen();
        break;
      default:
        return new Text("Error");
    }

    if (widgetToShow == null) {}
    return widgetToShow;
  }

  notificationInit() {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
        ///todo handle notification
        });

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     print("Message: ${message.data}");
    //     _controller!.animateTo(3);
    //   }
    // });
    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   showNotification(event.notification!.title, event.notification!.body);
    //   showNotification(event.notification!.title, event.notification!.body);
    // });
  }

  void showNotification(String? title, String? body) async {
    await _demoNotification(title!, body!);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel_ID', 'notification',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: '');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: body);
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  void initState() {
    notificationInit();
    generateAndSaveUserCartToken();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {

  }

  changeContentFromOutSide(int index) {
    setState(() => Constants.index = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _onSelectItem(int index) {
    setState(() => Constants.index = index);
    Navigator.of(context).pop(); // close the drawer
  }

  generateAndSaveUserCartToken() async {
    AuthClientGraphQL authClientGraphQL = AuthClientGraphQL();
    var tokenResult = await authClientGraphQL.customerCart();
    print("Customer cart token: $tokenResult, Current user token ${Session.shared.currentUser.accessToken}");
    if(tokenResult == 'error') {
      BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedOut());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get current customer cart token.')));
    } else {
      Constants.cartToken = tokenResult;
      await MySharedPreferences.instance.setStringValue('userCartToken', tokenResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Image.asset(
          d.icon,
          width: 20,
          fit: BoxFit.cover,
        ),
        title: new Text(
          d.title,
          style: TextStyle(
              color: whiteproject_black,
              fontSize: 20,
              fontWeight: FontWeight.normal),
        ),
        selected: i == Constants.index,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      key: _key,
      appBar: CustomAppBar(
          cartWidget: CartBadge(),
          title: '',
          elevation: 10,
          backIcon: SizedBox(
            height: 0,
          ),
          drawerIcon: GestureDetector(
            onTap: () {
              _key.currentState!.openDrawer();
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/hamburger_icon.png'))),
            ),
          ),
          showCart: true,
          drawer: true,
          onTap: () {}),
      drawer: new Drawer(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomLeft,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(left: 15, top: 50, bottom: 25),
                        child: Image.asset('images/logo_whiteproject.png'))
                  ],
                ),
              ),
              SingleChildScrollView(
                child: new Column(
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: drawerOptions,
                        ),
                      ),
                    ),
                    _subMenu(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(Constants.index),
    );
  }

  Widget _subMenu(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return Column(
      children: [
        ///notification tester
        // GestureDetector(
        //   onTap: () {showNotification('test', 'testbody');},
        //   child: Text('test notification')
        // ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Divider(
            color: Colors.grey,
            height: 20,
            thickness: 0.5,
          ),
        ),
        new ListTile(
          leading: new Image.asset(
            'images/call_for_help.png',
            width: 20,
            fit: BoxFit.cover,
          ),
          title: new Text(
            Stringswhiteproject.call_for_help,
            style: TextStyle(
                color: whiteproject_black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          onTap: () {
            if(Platform.isIOS) {
              _callNumber('0771707975');
            } else {
              _makePhoneCall("0771707975");
            }
          },
        ),
        new ListTile(
          leading: new Image.asset(
            'images/contact_us.png',
            width: 20,
            fit: BoxFit.cover,
          ),
          title: new Text(
            Stringswhiteproject.contact_us,
            style: TextStyle(
                color: whiteproject_black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ContactUs()),
            );
          },
        ),
        new ListTile(
          leading: new Image.asset(
            'images/log_out.png',
            width: 20,
            fit: BoxFit.cover,
          ),
          title: new Text(
            Stringswhiteproject.log_out,
            style: TextStyle(
                color: whiteproject_black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          onTap: () {
            pr.show(context, context);
            BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedOut());
          },
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                '© 2021 S.C. THE whiteproject S.R.L. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
            ],
          ),
        )
      ],
    );
  }

  _callNumber(String phoneNumber) async{
    var number = phoneNumber;
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
}
