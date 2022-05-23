import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whiteproject/app/profil/bloc/profile_bloc.dart';
import 'package:whiteproject/app/widgets/my_progress.dart';
import 'package:whiteproject/app/widgets/red_button_whiteproject.dart';
import 'package:whiteproject/app/widgets/text_form_field_whiteproject.dart';
import 'package:whiteproject/app/widgets/theme.dart';
import 'package:whiteproject/network_kit/models/user.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';

class ProfileDataUpdate extends StatefulWidget {
  final User user;
  ProfileDataUpdate({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileDataUpdateState createState() => _ProfileDataUpdateState(user: user);
}

class _ProfileDataUpdateState extends State<ProfileDataUpdate> {

  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  late MyProgress pr;
  User user;

  final AuthClientGraphQL clientGraphQL =  AuthClientGraphQL();

  _ProfileDataUpdateState({required this.user});

  @override
  Widget build(BuildContext context) {
    pr = new MyProgress(context, type: MyProgressType.Normal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Contact details",
            style: WholeAppTheme.lightTextTheme.headline2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormFieldWine(
              TextInputType.text, "Nume", user.lastName, name),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormFieldWine(
              TextInputType.text, "Prenume", user.firstName, lastName),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormFieldWine(TextInputType.emailAddress,
              "Adresa Email", user.email, email),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextFormFieldWine(
        //       TextInputType.phone, "Numar telefon", "", phone),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RedButtonWine(
                () async {
              pr.show(context, context);
              var response = await clientGraphQL.updateCustomerData(email: email.text, lastName: name.text, firstName: lastName.text);
              if(response.firstName.isEmpty || response.email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update error. Try again later.')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile data updated!')));
                  email.text = response.email;
                  name.text = response.lastName;
                  lastName.text = response.firstName;
              }
              pr.hide(context);
            },
            "Save",
          ),
        ),
      ],
    );
  }
}
