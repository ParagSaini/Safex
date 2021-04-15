import 'package:flutter/material.dart';
import 'package:safex/screens/group_screen.dart';
import 'package:safex/screens/home_screen.dart';
import 'package:safex/screens/login_screen.dart';
import 'package:safex/screens/qr_generate_screen.dart';
import 'package:safex/screens/register_screen.dart';
import 'package:safex/screens/welcome_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed while calling Navigator.pushNamed.
    final args = settings.arguments;
    switch (settings.name) {
      case WelcomeScreen.id:
        return MaterialPageRoute(builder: (context) => WelcomeScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RegistrationScreen.id:
        return MaterialPageRoute(builder: (context) => RegistrationScreen());
      case HomePageScreen.id:
        return MaterialPageRoute(builder: (context) => HomePageScreen());
      case QrGenerateScreen.id:
        if (args is String) {
          return MaterialPageRoute(
            builder: (context) => QrGenerateScreen(groupId: args),
          );
        }
        return _errorRoute();
      case GroupScreen.id:
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => GroupScreen(
                    groupId: args,
                  ));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
