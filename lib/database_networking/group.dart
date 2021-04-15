import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safex/database_networking/endUser.dart';
import 'package:safex/main.dart';
import 'package:safex/models/group_boxes_data.dart';

class Group {
  final _firestore = FirebaseFirestore.instance;

  void showNegativeError(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> createGroup(String groupName, BuildContext context) async {
    try {
      User currentUser = loggedInUser.getLoggedInUser();
      final currentUserUid = currentUser.uid;
      final currentUserEmail = currentUser.email;
      String currentUserName = '';

      await _firestore
          .collection('users')
          .doc(currentUserUid)
          .get()
          .then((userData) => currentUserName = userData.data()['name']);

      final x = DateTime.now();
      String date =
          x.day.toString() + '/' + x.month.toString() + '/' + x.year.toString();
      final group = await _firestore.collection('groups').add({
        'name': groupName,
        'userCreated': currentUserEmail,
        'members': [currentUserUid],
        'dateCreated': date,
        'adminName': currentUserName,
      });
      await EndUser().addGroupToCurrentUser(group.id);
      Provider.of<GroupBoxData>(context, listen: false).addGroupToUser(
          groupId: group.id,
          groupName: groupName,
          createdOn: date,
          createdBy: currentUserEmail,
          adminName: currentUserName);
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  Future<void> joinGroup(String groupId, BuildContext context) async {
    List<dynamic> temp = [loggedInUser.getLoggedInUser().uid];
    String groupName, createdOn, createdBy, adminName;
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .update({'members': FieldValue.arrayUnion(temp)});
      await _firestore.collection('groups').doc(groupId).get().then((doc) => {
            groupName = doc.data()['name'],
            createdOn = doc.data()['dateCreated'],
            createdBy = doc.data()['userCreated'],
            adminName = doc.data()['adminName'],
          });
      await EndUser().addGroupToCurrentUser(groupId);
      Provider.of<GroupBoxData>(context, listen: false).addGroupToUser(
          groupName: groupName,
          groupId: groupId,
          createdOn: createdOn,
          createdBy: createdBy,
          adminName: adminName);
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  Future<void> leaveGroup(String groupId, BuildContext context) async {
    String userId = loggedInUser.getLoggedInUser().uid;
    List<dynamic> temp1 = [userId];
    List<dynamic> temp2 = [groupId];
    var groupRef = _firestore.collection('groups').doc(groupId);
    var userRef = _firestore.collection('users').doc(userId);
    bool onlyOneMember = await groupRef.get().then((groupData) {
      List<dynamic> groupMember = groupData.data()['members'];
      if (groupMember.length == 1)
        return true;
      else
        return false;
    });
    if (onlyOneMember)
      await groupRef.delete();
    else {
      await groupRef.update({
        'members': FieldValue.arrayRemove(temp1),
      });
    }
    await userRef.update({
      'groupIds': FieldValue.arrayRemove(temp2),
    });
    Provider.of<GroupBoxData>(context, listen: false)
        .deleteGroupFromList(groupId);
  }

  Future<bool> validGroupId(String groupId) async {
    final String curUser = loggedInUser.getLoggedInUser().uid;
    bool validGroup = false;
    List<dynamic> members = [];
    try {
      final groupRef = _firestore.collection('groups').doc(groupId);
      await groupRef.get().then((doc) => {
            if (doc.exists)
              {
                members = doc.data()['members'],
                if (!members.contains(curUser))
                  {validGroup = true}
                else
                  {showNegativeError('You are already in this group')}
              }
            else
              showNegativeError('Invalid Group'),
          });
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
    return validGroup;
  }
}
