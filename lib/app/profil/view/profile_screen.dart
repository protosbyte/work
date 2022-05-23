import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteproject/app/navigation_service.dart';
import 'package:whiteproject/app/profil/bloc/profile_bloc.dart';
import 'package:whiteproject/app/profil/view/billing_info.dart';
import 'package:whiteproject/app/profil/view/notification_setup_section.dart';
import 'package:whiteproject/app/profil/view/profile_data_update.dart';
import 'package:whiteproject/app/profil/view/profile_password_update.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button_whiteproject.dart';
import 'package:whiteproject/app/widgets/text_form_field_whiteproject.dart';
import 'package:whiteproject/app/widgets/theme.dart';
import 'package:whiteproject/network_kit/models/user.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';

import '../../../locator.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen();

  static Route route() {
    return MaterialPageRoute(builder: (_) => ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfile()),
      child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {}, child: ProfileScreenPage()),
    );
  }
}

class ProfileScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreenPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MyProgress pr;
  AuthClientGraphQL client = AuthClientGraphQL();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return state is ProfileLoading
            ? Center(
                child: Container(
                    width: 150,
                    child: LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Colors.transparent,
                    )))
            : state is ProfileLoaded
                ? profileBody(context, state.user)
                : state is Failure
                    ? Center(
                        child: Text('Error occurred. Please login again.'),
                      )
                    : Center(
                        child: Container(
                            width: 150,
                            child: LinearProgressIndicator(
                              color: Colors.red,
                              backgroundColor: Colors.transparent,
                            )));
      },
    );
  }

  Widget profileBody(BuildContext profileBodyContext, User user) {
    pr = new MyProgress(context, type: MyProgressType.Normal);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: () {
            //     locator<NavigationService>().push(BillingInfo.route());
            //   },
            //   child: Container(
            //       padding: EdgeInsets.only(left: 20, right: 20),
            //       width: double.infinity,
            //       height: 48,
            //       color: vanilla,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Expanded(
            //               flex: 8,
            //               child: Text(
            //                 'Billing information',
            //                 style: TextStyle(color: whiteproject_red, fontSize: 16),
            //               )),
            //           Expanded(
            //               flex: 1,
            //               child: Icon(
            //                 Icons.arrow_forward_ios_rounded,
            //                 color: whiteproject_red,
            //                 size: 15,
            //               )),
            //         ],
            //       )),
            // ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ProfileDataUpdate(user: user),
                  SizedBox(
                    height: 30,
                  ),
                  NotificationSetupSection(),
                  SizedBox(
                    height: 30,
                  ),
                  ProfilePWUpdate(),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Delete account",
                              style: WholeAppTheme.lightTextTheme.headline2,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Deleting your account will remove all of the data associated with it from our database. By clicking the button bellow, you agree with this.",
                                style: TextStyle(
                                    fontSize: 16, color: whiteproject_grey_2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        WhiteButton(
                          () async {},
                          "DELETE MY ACCOUNT",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
