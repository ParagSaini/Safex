import 'package:flutter/material.dart';
import 'package:safex/constant.dart';
import 'package:safex/main.dart';
import 'package:safex/models/location_on_map.dart';
import 'package:provider/provider.dart';

class GroupMemberSideSheet extends StatelessWidget {
  GroupMemberSideSheet({this.uid, @required this.userName});
  final uid;
  final userName;
  final int n = (DateTime.now().millisecond % 9) + 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: GestureDetector(
        onTap: () {
          Provider.of<LocationOnMap>(context, listen: false)
              .updateMarkerAndCircle(uid: uid, userName: userName);

          Navigator.pop(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/male/$n.jpg'),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  uid == loggedInUser.getLoggedInUser().uid ? 'You' : userName,
                  style: kTextFontStyle.copyWith(
                    fontSize: 20,
                    color: Colors.black,
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
