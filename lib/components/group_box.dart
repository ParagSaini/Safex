import 'package:flutter/material.dart';
import 'package:safex/alerts_box/alert_dialogs.dart';
import 'package:safex/constant.dart';
import 'package:safex/database_networking/group.dart';
import 'package:safex/main.dart';
import 'file:///D:/Programming/Android_Studio_Project/safex/lib/models/loading_animation.dart';
import 'package:safex/screens/group_screen.dart';
import 'package:safex/screens/qr_generate_screen.dart';

class GroupBox extends StatelessWidget {
  GroupBox({
    this.groupId,
    this.groupName,
    this.createdOn,
    this.createdBy,
    this.adminName,
  });
  final adminName, groupId, groupName, createdBy, createdOn;
  final curUser = loggedInUser.getLoggedInUser();
  final int n = (DateTime.now().millisecond % 9) + 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, GroupScreen.id, arguments: groupId);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black45,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              children: [
                CircleAvatar(
                  // backgroundColor: Colors.teal[100],
                  radius: 30.0,
                  backgroundImage: AssetImage('images/male/$n.jpg'),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              groupName,
                              style: kTextFontStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          PopupMenuButton<int>(
                            color: Colors.white,
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Text(
                                  "Share",
                                  style: kTextFontStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // PopupMenuItem(
                              //   value: 1,
                              //   child: Text(
                              //     "Leave Group",
                              //     style: kTextFontStyle.copyWith(
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.black,
                              //     ),
                              //   ),
                              // ),
                            ],
                            onSelected: (int index) async {
                              if (index == 0) {
                                Navigator.pushNamed(
                                    context, QrGenerateScreen.id,
                                    arguments: groupId);
                              }
                              // else if (index == 1) {
                              //   bool leave = false;
                              //   leave = await AlertBoxes()
                              //       .showLeaveGroupDialog(context);
                              //   print(leave);
                              //   if (leave) {
                              //     Navigator.pushNamed(
                              //         context, LoadingScreen.id);
                              //     await Group().leaveGroup(groupId, context);
                              //     Navigator.pop(context);
                              //   }
                              // }
                            },
                            // offset: Offset(0, 100),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Created by:',
                              style: TextStyle(
                                color: Colors.white60,
                                fontFamily: 'Karla',
                              ),
                            ),
                          ),
                          Text(
                            'Created on:',
                            style: TextStyle(
                              color: Colors.white60,
                              fontFamily: 'Karla',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              createdBy == curUser.email ? 'You' : adminName,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Karla',
                              ),
                            ),
                          ),
                          Text(
                            createdOn,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Karla',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
