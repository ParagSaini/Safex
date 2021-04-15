import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safex/components/group_box.dart';

/// This UserDataStream is useless now as we are using the
/// Provider package in group_boxes_data.dart to do the same thing
/// we want to do with this class.

class UserDataStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final loggedInUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(loggedInUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<GroupBox> groupBoxes = [];
        for (var groupId in snapshot.data['groupIds']) {
          groupBoxes.add(
            GroupBox(
              groupId: groupId,
            ),
          );
        }
        // return FutureBuilder(builder: ())
        return Expanded(
          child: ListView(
            children: groupBoxes,
          ),
        );
      },
    );
  }
}
