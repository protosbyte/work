import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:whiteboard/app/cart/bloc/cart_bloc.dart';
import 'package:whiteboard/app/cart/view/address_list_for_cart.dart';
import 'package:whiteboard/app/cart/view/cart_list_tile.dart';
import 'package:whiteboard/app/cart/view/coupon_field.dart';
import 'package:whiteboard/app/cart/view/payment_methode_list.dart';
import 'package:whiteboard/app/cart/view/sub_total_section.dart';
import 'package:whiteboard/app/cart/view/thank_you_view.dart';
import 'package:whiteboard/app/mini_cart/view/cart_badge_widget.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/app/utils/constants.dart';
import 'package:whiteboard/app/widgets/error_widget.dart';
import 'package:whiteboard/app/widgets/my_appbar.dart';
import 'package:whiteboard/app/widgets/my_progress.dart';
import 'package:whiteboard/app/widgets/red_button.dart';
import 'package:whiteboard/app/widgets/very_good_infinite_list.dart';
import 'package:whiteboard/datakit/models/address_list_model.dart';
import 'package:whiteboard/datakit/models/cart.dart';
import 'package:whiteboard/datakit/repository/cart/cart_client.dart';
import 'my_subtitle.dart';

class MyCart extends StatefulWidget{
  final String cartToken;

  MyCart({required this.cartToken});

  static Route route(String cartToken) {
    return routeWith(cartToken);
  }

  static Route routeWith(String cartToken) {
    return MaterialPageRoute<void>(
        builder: (_) => MyCart(
          cartToken: cartToken,
        ));
  }

  @override
  State<StatefulWidget> createState() {
    return MyCartState(cartToken: cartToken);
  }
}
class MyCartState extends State<MyCart> {
  final String cartToken;
  final CartClient cartClient = CartClient();
  final GlobalKey<InfiniteListState> infiniteListStateKey = GlobalKey();
  double subTotal = 0.0;
  double taxe = 0.0;
  double otherTax = 0.0;
  double total = 0.0;
  String currency = '';
  List<PaymentMethod> availablePaymentMethods = [];
  List<AddressList> addresses = [];
  List<Tax> appliedTaxes = [];
  List<Discount> discounts = [];
  late MyProgress pr;
  GlobalKey<CartBadgeWidgetState> _myKey = GlobalKey();

  MyCartState({required this.cartToken});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CartBloc(cartClient)..add(LoadingCart(cartToken: cartToken)),
      child: buildContent(context),
    );
  }

  refresh() {
    _myKey.currentState!.refresh();
  }

  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: vanilla,
      appBar: CustomAppBar(
        cartWidget: CartBadge(key: _myKey,),
        title: 'CHECKOUT',
        elevation: 10,
        backIcon: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: whiteboard_red,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        drawerIcon: SizedBox(
          height: 0,
        ),
        showCart: false,
        onTap: () {},
        drawer: false,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Container(
            padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 10),
            alignment: Alignment.topLeft,
            child: _createGridList(context))
      ),
    );
  }

  Widget _createGridList(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartRefreshed) {
            infiniteListStateKey.currentState?.refresh();
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
            buildWhen: (context, state) => !(state is CartRefreshed),
            builder: (context, state) {
              return SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      child: InfiniteList<Item>(
                        key: infiniteListStateKey,
                        padding: const EdgeInsets.only(bottom: 40),
                        itemLoader: _itemLoader,
                        isGrid: false,
                        builder: InfiniteListBuilder<Item>(
                          empty: (context) => MyEmptyWidget(),
                          loading: (context) => MyLoadingWidget(),
                          success: (context, item) =>
                              CartListTile(cartToken: cartToken, product: item),
                          error: (context, retry, error) {
                            return MyErrorWidget(error: error, retry: retry);
                          },
                        ),
                        bottomLoader: (context) => SizedBox(),
                        errorLoader: (context, retry, error) =>
                            MyErrorLoader(retry: retry),
                      ),
                    ),
                    subTotal == 0.0
                        ? SizedBox(
                      height: 0,
                    )
                        : SubTotalSection(
                      isHistory: false,
                      delivery: 0,
                      value: subTotal,
                      currency: currency,
                      tax: taxe,
                      discount: 0.0,
                      appliedTaxes: appliedTaxes,
                      discounts: discounts,
                    ),
                    // CouponField(total: total, currency: currency),
                    SizedBox(
                      height: 20,
                    ),
                    CouponField(
                      token: widget.cartToken,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20),
                                textAlign: TextAlign.start,
                              )),
                          Expanded(
                              child: Text(
                                total.toString() + currency,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 20),
                                textAlign: TextAlign.end,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    deliveryInfo(context),
                  ]));
            }));
  }

  Future<List<Item>?> _itemLoader(int limit, {int start = 1}) async {
    availablePaymentMethods.clear();
    appliedTaxes.clear();
    discounts.clear();
    Cart result = await cartClient.getCartContent(cartToken: cartToken);
    setState(() {
      subTotal = result.prices.subtotalExcludingTax.value;
      total = result.prices.grandTotal.value;
      currency = result.prices.grandTotal.currency;
      availablePaymentMethods.addAll(result.availablePaymentMethods);
      addresses.addAll(result.shippingAddresses);
      taxe = result.prices.grandTotal.value -
          result.prices.subtotalIncludingTax.value;
      otherTax = result.prices.subtotalIncludingTax.value -
          result.prices.subtotalExcludingTax.value;
      appliedTaxes.addAll(result.prices.appliedTaxes);
      discounts.addAll(result.prices.discounts);
      Constants.count = result.items.length;
    });

    return result.items;
  }

  Widget deliveryInfo(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      color: Colors.white,
      child: Column(
        children: [
          MySubTitle(
            text: 'Delivery information',
            fontSize: 20,
          ),
          SizedBox(
            height: 5,
          ),
          MySubTitle(
            text: 'Address',
            fontSize: 16,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              child: AddressListForCartWidget(
                preSelectAddresses: addresses,
                cartToken: cartToken,
              )),
          SizedBox(
            height: 10,
          ),
          MySubTitle(text: 'Payment', fontSize: 16),
          PaymentMethodeTile(
            cartToken: cartToken,
            availablePaymentMethods: availablePaymentMethods,
          ),
          MySubTitle(text: "Message", fontSize: 16),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: TextField(
              cursorColor: whiteboard_red,
              maxLines: null,
              enabled: true,
              onChanged: (value) async {},
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Message',
                hintStyle: TextStyle(color: whiteboard_dark_grey),
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: whiteboard_dark_grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: whiteboard_dark_grey,
                    )),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: whiteboard_dark_grey),
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.red)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: RedButton(
              text: "SEND ORDER",
              onPress: () async {
                pr.show(context, context);
                var placeOrderResult =
                await cartClient.placeOrder(cartToken: cartToken);
                if (placeOrderResult == "1") {
                  pr.hide(context);
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => ThankYouView(),
                  );
                } else {
                  pr.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(placeOrderResult.toString())));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
