import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteproject/app/mini_cart/view/cart_badge_widget.dart';
import 'package:whiteproject/app/profil/bloc/profile_bloc.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/my_appbar.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button_whiteproject.dart';
import 'package:whiteproject/app/widgets/text_form_field_whiteproject.dart';

class BillingInfo extends StatefulWidget {
  const BillingInfo({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => BillingInfo());
  }

  @override
  _BillingInfoState createState() => _BillingInfoState();
}

class _BillingInfoState extends State<BillingInfo> {

  TextEditingController company = TextEditingController();
  TextEditingController cui = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  late MyProgress pr;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {}, child: buildContent(context)),
    );
  }

  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'BILLING INFO',
        elevation: 10,
        backIcon: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: whiteproject_red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        drawerIcon: SizedBox(
          height: 0,
        ),
        showCart: false,
        onTap: () {},
        drawer: false,
        cartWidget: CartBadge(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormFieldWine(
                TextInputType.text, "Company Name", '', company),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormFieldWine(
                TextInputType.text, "CUI", '', cui),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormFieldWine(TextInputType.emailAddress,
                "Address", '', address),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormFieldWine(
                TextInputType.phone, "Phone", "", phone),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RedButtonWine(
                  () {},
              "Save",
            ),
          ),
        ],
      ),
    );
  }
}
