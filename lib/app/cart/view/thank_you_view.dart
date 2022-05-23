import 'package:flutter/material.dart';
import 'package:whiteboard/app/home/view/home_page.dart';
import 'package:whiteboard/app/utils/colors.dart';
import 'package:whiteboard/app/utils/strings.dart';
import 'package:whiteboard/app/utils/styles.dart';

import '../../../locator.dart';
import '../../../../navigation_service.dart';

class ThankYouView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.check,
              color: whiteboard_red,
              size: 150,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                Stringswhiteboard.thank_you,
                style: wb_bold_black_text_style,
              )),
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  Stringswhiteboard.thank_you_text,
                  style: wb_normal_grey_text_style,
                ),
              )),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child:SizedBox(
                width: double.maxFinite,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top:0.0, right: 16.0, bottom:16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      locator<NavigationService>().pushAndRemoveUntil(HomePage.route());
                    },
                    style: wbRedButtonTextStyle,
                    child: Text(Stringswhiteboard.okay),
                  ),
                ),
              )
          ),
        ],
      ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 10,
              blurRadius: 7,
              offset: Offset(0, -5), // changes position of shadow
            ),
          ],
        ),
    );
  }
}
