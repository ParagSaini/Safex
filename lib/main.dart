import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safex/models/logged_in_user.dart';
import 'package:safex/routing/route_generator.dart';
import 'package:safex/screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safex/models/group_boxes_data.dart';
import 'package:safex/models/group_data.dart';
import 'package:safex/models/location_on_map.dart';
import 'package:firebase_core/firebase_core.dart';

// Firestore and realtime database do not throw error on no data connection,They will
// silently retry the connection in hopes that the device will regain
// network connectivity soon.

LoggedInUser loggedInUser = LoggedInUser();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } on FirebaseException catch (e) {
    Fluttertoast.showToast(msg: e.message, backgroundColor: Colors.red);
    SystemNavigator.pop();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GroupBoxData(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupData(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationOnMap(),
        ),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Color(0xFFDBC9B4),
      ),
      initialRoute:
          loggedInUser.isUserNull() ? WelcomeScreen.id : HomePageScreen.id,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
