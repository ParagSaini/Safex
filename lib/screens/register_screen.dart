import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:safex/ask_for_permission.dart';
import 'package:safex/components/text_form_field.dart';
import 'package:safex/components/rounded_button.dart';
import 'package:safex/database_networking/endUser.dart';
import 'package:safex/models/loading_animation.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  String _email, _password, _name;

  Future<void> _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        _showSpinner = true;
      });

      AskForPermission checkPermissions = AskForPermission();
      bool gotPermissions = await checkPermissions.check(context);
      GeoPoint pos = checkPermissions.getGeoPoint;
      double accuracy = checkPermissions.getAccuracy;
      if (gotPermissions && pos != null && accuracy != null) {
        print(pos.longitude);
        print(accuracy);
        await EndUser().createUserAndSendVerificationLink(
            _email, _password, _name, pos, accuracy, context);
      }
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_showSpinner == true)
          return Future.value(false);
        else
          return Future.value(true);
      },
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          progressIndicator: LoadingAnimation.progressIndicator,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background1.PNG'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.data_usage_outlined,
                            size: 60.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'SafeX',
                            style: TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                    MyTextFormField(
                      leadingIcon: Icons.account_circle,
                      hintText: '*Enter your name',
                      validator: (input) => input.toString().trim().isNotEmpty
                          ? null
                          : "Name can't be empty",
                      onSaved: (input) => _name = input.toString(),
                    ),
                    MyTextFormField(
                      leadingIcon: Icons.email_outlined,
                      hintText: '*Enter your email id',
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        bool isValid = EmailValidator.validate(input);
                        if (isValid) return null;
                        return 'Enter a valid email';
                      },
                      onSaved: (input) => _email = input.toString(),
                    ),
                    MyTextFormField(
                      leadingIcon: Icons.vpn_key,
                      hintText: '*Enter your Password',
                      obscureText: true,
                      validator: (input) => (input.toString().length >= 8)
                          ? null
                          : "Password should atleast contains 8 characters",
                      onSaved: (input) => _password = input.toString(),
                    ),
                    RoundedButton(
                      label: 'Verify Email and Register',
                      colour: Colors.white,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
