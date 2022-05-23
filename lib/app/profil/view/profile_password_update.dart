import 'package:flutter/material.dart';
import 'package:whiteproject/app/utils/colors.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button_whiteproject.dart';
import 'package:whiteproject/app/widgets/theme.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';


class ProfilePWUpdate extends StatefulWidget {
  const ProfilePWUpdate({Key? key}) : super(key: key);

  @override
  _ProfilePWUpdateState createState() => _ProfilePWUpdateState();
}

class _ProfilePWUpdateState extends State<ProfilePWUpdate> {
  AuthClientGraphQL client = AuthClientGraphQL();
  TextEditingController passOld = TextEditingController();
  TextEditingController passNew = TextEditingController();
  TextEditingController passConfirm = TextEditingController();
  late MyProgress pr;
  bool showPassOld = true;
  bool showPassNew = true;
  bool showPassConfirm = true;

  @override
  Widget build(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Change password",
            style: WholeAppTheme.lightTextTheme.headline2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              obscureText: showPassOld,
              controller: passOld,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(showPassOld?Icons.remove_red_eye:Icons.visibility_off, color: whiteproject_grey_2,), onPressed: () {
                  setState(() {
                    showPassOld =! showPassOld;
                  });
                },),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                border: const OutlineInputBorder(),
                hintText: "Current Password",
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              obscureText: showPassNew,
              controller: passNew,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(showPassNew?Icons.remove_red_eye:Icons.visibility_off, color: whiteproject_grey_2,), onPressed: () {
                  setState(() {
                    showPassNew =! showPassNew;
                  });
                },),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                border: const OutlineInputBorder(),
                hintText: "New Password",
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              obscureText: showPassConfirm,
              controller: passConfirm,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: Icon(showPassConfirm?Icons.remove_red_eye:Icons.visibility_off, color: whiteproject_grey_2,), onPressed: () {
                  setState(() {
                    showPassConfirm =! showPassConfirm;
                  });
                },),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteproject_red, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                border: const OutlineInputBorder(),
                hintText: "Confirm Password",
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RedButtonWine(
                () async{
              pr.show(context, context);
              if(passConfirm.text == passNew.text) {
                var res = await client.updatePassword(newPass: passNew.text, oldPass: passOld.text);
                if(res != "1") {
                  pr.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                } else {
                  pr.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password change success!')));
                }
              } else {
                pr.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords doesn't match")));
              }
            },
            "Save",
          ),
        ),
      ],
    );
  }
}
