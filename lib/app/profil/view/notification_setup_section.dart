import 'package:flutter/material.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/theme.dart';

class NotificationSetupSection extends StatefulWidget {
  const NotificationSetupSection({Key? key}) : super(key: key);

  @override
  _NotificationSetupSectionState createState() => _NotificationSetupSectionState();
}

class _NotificationSetupSectionState extends State<NotificationSetupSection> {
  bool orders = false;
  bool news = false;
  bool marketing = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Notification settings",
            style: WholeAppTheme.lightTextTheme.headline2,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Checkbox(
                  activeColor: whiteproject_red,
                  checkColor: Colors.white,
                  value: orders,
                  onChanged: (v) {
                    print(v);
                    setState(() {
                      orders = v!;
                    });
                  }),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: 'Orders (important)',style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: '\nSome addition description here that could continue on two rows if needed.',
                            style: TextStyle(
                                color: whiteproject_grey_2, fontSize: 13),
                        )
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Checkbox(
                  activeColor: whiteproject_red,
                  checkColor: Colors.white,
                  value: news,
                  onChanged: (v) {
                    print(v);
                    setState(() {
                      news = v!;
                    });
                  }),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: 'News',style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: '\nSome addition description here that could continue on two rows if needed.',
                          style: TextStyle(
                              color: whiteproject_grey_2, fontSize: 13),
                        )
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              Checkbox(
                  activeColor: whiteproject_red,
                  checkColor: Colors.white,
                  value: marketing,
                  onChanged: (v) {
                    print(v);
                    setState(() {
                      marketing = v!;
                    });
                  }),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: 'Marketing',style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: '\nSome addition description here that could continue on two rows if needed.',
                          style: TextStyle(
                              color: whiteproject_grey_2, fontSize: 13),
                        )
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
