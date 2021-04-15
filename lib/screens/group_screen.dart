import 'package:safex/alerts_box/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:safex/constant.dart';
import 'package:safex/database_networking/group.dart';
import 'package:safex/models/group_data.dart';
import 'package:safex/models/location_on_map.dart';
import 'package:safex/models/logged_in_user.dart';
import 'file:///D:/Programming/Android_Studio_Project/safex/lib/models/loading_animation.dart';
import 'package:safex/screens/side_sheet.dart';

class GroupScreen extends StatefulWidget {
  static const String id = 'group_screen';

  GroupScreen({@required this.groupId});
  final groupId;
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showSpinner = false;
  final int n = (DateTime.now().millisecond % 9) + 1;

  Future<void> _onLeaveButtonPressed() async {
    bool leave = false;
    leave = await AlertBoxes().showBinaryDialog(
        context: context, title: 'Do you really want to leave the group?');
    if (leave) {
      setState(() {
        _showSpinner = true;
      });
      await Group().leaveGroup(widget.groupId, context);
      Navigator.pop(context);
      setState(() {
        _showSpinner = false;
      });
    }
  }

  Future<void> _initialiseGroupScreen(String groupId) async {
    setState(() {
      _showSpinner = true;
    });
    await Provider.of<GroupData>(context, listen: false)
        .initialiseGroupScreen(groupId, context);
    setState(() {
      _showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialiseGroupScreen(widget.groupId);
  }

  @override
  Future<void> deactivate() async {
    Provider.of<GroupData>(context, listen: false).clearList();
    Provider.of<LocationOnMap>(context, listen: false).setMarkerToNull();
    super.deactivate();
    await Provider.of<LocationOnMap>(context, listen: false).cancelStream();
    print('The group Screen deactivated');
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
      child: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        progressIndicator: LoadingAnimation.progressIndicator,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SideSheet(),
          ),
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Provider.of<LocationOnMap>(context).getGoogleMap(),
                  Positioned(
                    bottom: 140,
                    right: 10,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.outbond,
                        ),
                        radius: 24,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: _onLeaveButtonPressed,
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 10,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.layers,
                        ),
                        radius: 24,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Provider.of<LocationOnMap>(context, listen: false)
                            .toggleMapType();
                      },
                    ),
                  ),
                  Positioned(
                    right: 10.0,
                    bottom: 20.0,
                    child: RawMaterialButton(
                      elevation: 20.0,
                      constraints: BoxConstraints(),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.group_rounded,
                          size: 30.0,
                        ),
                        radius: 24.0,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ),
                  Visibility(
                    visible:
                        Provider.of<LocationOnMap>(context).markerNotNull(),
                    child: Positioned(
                      top: 10,
                      right: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0.5,
                                ),
                              ]),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/male/$n.jpg'),
                                radius: 15.0,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Text(
                                  Provider.of<LocationOnMap>(context)
                                      .getSelectedUserName(),
                                  textAlign: TextAlign.center,
                                  style: kTextFontStyle.copyWith(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
