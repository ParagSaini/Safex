import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safex/components/my_appbar.dart';
import 'package:safex/components/rounded_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background2.PNG'), fit: BoxFit.fill),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyAppBar(
                title: 'SafeX',
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage('images/image.jpg'),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Welcome to the SafeX',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontFamily: 'Source Sans Pro',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Stay connected when you can't be there with your loved ones",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Karla',
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      RoundedButton(
                        label: 'Login Now',
                        colour: Color(0xFFDBC9B4),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                      RoundedButton(
                        label: 'Create Account',
                        colour: Colors.grey.shade200,
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
