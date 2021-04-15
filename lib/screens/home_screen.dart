import 'package:fluttertoast/fluttertoast.dart';
import 'package:safex/components/my_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:safex/alerts_box/alert_dialogs.dart';
import 'package:safex/components/noGroupView.dart';
import 'package:safex/constant.dart';
import 'package:safex/database_networking/endUser.dart';
import 'package:safex/database_networking/group.dart';
import 'package:safex/main.dart';
import 'package:safex/models/group_boxes_data.dart';
import 'package:safex/models/loading_animation.dart';
import 'package:safex/models/location_tracking.dart';
import 'package:safex/screens/qr_scanner_screen.dart';
import 'package:safex/screens/welcome_screen.dart';

class HomePageScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  LocationTracking _locationTracking = LocationTracking();

  void _showError(String error) {
    Fluttertoast.showToast(
      msg: error,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> _createGroupButton() async {
    String _newGroupName = '';
    await AlertBoxes().textFieldDialog(
        title: 'Enter your Group name',
        context: context,
        onPressed: (text) {
          _newGroupName = text;
          Navigator.pop(context);
        });
    setState(() {
      _showSpinner = true;
    });
    if (_newGroupName.isNotEmpty) {
      await Group().createGroup(_newGroupName, context);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _joinGroupButton() async {
    String joinGroupId = '';
    setState(() {
      _showSpinner = true;
    });
    joinGroupId = await QrScannerScreen().scanQrCode();
    if (joinGroupId.isNotEmpty && await Group().validGroupId(joinGroupId)) {
      await Group().joinGroup(joinGroupId, context);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _initialiseHomeScreen() async {
    await Provider.of<GroupBoxData>(context, listen: false)
        .initialiseHomeScreen();
  }

  Future<void> _doInitialisation() async {
    setState(() {
      _showSpinner = true;
    });
    await _initialiseHomeScreen();
    await _locationTracking.subscribeToUserLocation();

    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _onSignOutUser() async {
    bool leave = await AlertBoxes().showBinaryDialog(
      context: context,
      title: 'Do you want to sign out?',
    );
    if (leave) {
      setState(() {
        _showSpinner = true;
      });
      if (await EndUser().signOutAccount()) {
        try {
          await _auth.signOut();
          loggedInUser.signOutUser();
          await _locationTracking.cancelSubscription();
          Navigator.popAndPushNamed(context, WelcomeScreen.id);
        } catch (e) {
          _showError(e.toString());
        }
      }
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _doInitialisation();
  }

  @override
  // runs whenever that page reconstructed on different user logins
  void deactivate() {
    super.deactivate();
    // we are not doing this in dispose as we GroupBoxData is the
    // ancestor of homeScreen, so it gives error.
    Provider.of<GroupBoxData>(context, listen: false).clearList();
    print('The deactivated and clear list successfully home screeen');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showSpinner == true)
          return Future.value(false);
        else {
          if (await _locationTracking.cancelSubscription())
            return Future.value(true);
          return Future.value(false);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: LoadingAnimation.progressIndicator,
        child: Scaffold(
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background1.PNG'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                children: [
                  MyAppBar(
                    title: 'SafeX',
                    trailingIcon: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    iconPressed: _onSignOutUser,
                  ),
                  Expanded(
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Provider.of<GroupBoxData>(context).getListLength() ==
                                  0
                              ? NoGroupView()
                              : ListView(
                                  children: List<Widget>.from(
                                      Provider.of<GroupBoxData>(context)
                                          .getList()),
                                ),
                          Positioned(
                            bottom: 15.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Tooltip(
                                  message: 'Create Group',
                                  preferBelow: false,
                                  verticalOffset: 35,
                                  textStyle: kTextFontStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  child: RawMaterialButton(
                                    fillColor: Colors.white,
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.all(10.0),
                                    shape: CircleBorder(),
                                    onPressed: _createGroupButton,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Tooltip(
                                  message: 'Join Group',
                                  preferBelow: false,
                                  verticalOffset: 35,
                                  textStyle: kTextFontStyle.copyWith(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  child: RawMaterialButton(
                                    fillColor: Colors.white,
                                    padding: EdgeInsets.all(10.0),
                                    constraints: BoxConstraints(),
                                    shape: CircleBorder(),
                                    onPressed: _joinGroupButton,
                                    child: Icon(
                                      Icons.group_add,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
