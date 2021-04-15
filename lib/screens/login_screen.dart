import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:safex/alerts_box/alert_dialogs.dart';
import 'package:safex/components/text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safex/database_networking/endUser.dart';
import 'package:safex/main.dart';
import 'file:///D:/Programming/Android_Studio_Project/safex/lib/models/loading_animation.dart';
import 'home_screen.dart';
import '../constant.dart';
import 'file:///D:/Programming/Android_Studio_Project/safex/lib/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showSpinner = false;
  String _email;
  String _password;
  final formKey = GlobalKey<FormState>();

  Future<void> _verifyEmailButton() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        _showSpinner = true;
      });
      await EndUser().verifyEmail(_email, _password);
      setState(() {
        _showSpinner = false;
      });
    }
  }

  Future<void> _onPasswordReset() async {
    String enteredEmail = '';
    await AlertBoxes().textFieldDialog(
        title: 'Enter your Email',
        context: context,
        onPressed: (email) {
          enteredEmail = email;
          Navigator.pop(context);
        });
    if (enteredEmail.isNotEmpty) {
      setState(() {
        _showSpinner = true;
      });
      await EndUser().forgotPassword(
        context: context,
        email: enteredEmail,
      );
      setState(() {
        _showSpinner = false;
      });
    }
  }

  Future<void> _submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        _showSpinner = true;
      });

      User curUser = await EndUser().loginUser(_email, _password);
      if (curUser != null) {
        loggedInUser.setLoggedInUser(curUser);
        Navigator.pushNamedAndRemoveUntil(
            context, HomePageScreen.id, (route) => false);
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
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                            style: kTextFontStyle.copyWith(fontSize: 40.0),
                          ),
                        ],
                      ),
                    ),
                    MyTextFormField(
                      leadingIcon: Icons.email_outlined,
                      hintText: '*Enter your Email id',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RawMaterialButton(
                          onPressed: _verifyEmailButton,
                          child: Text(
                            'Get Verification Link',
                            style: kTextFontStyle.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: _onPasswordReset,
                          child: Text(
                            'Forgot Password?',
                            style: kTextFontStyle.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    RoundedButton(
                      label: 'Get Started',
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
