import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safex/components/group_box.dart';
import 'package:safex/main.dart';
import 'package:safex/screens/welcome_screen.dart';

/// We are using the Provider package instead of UserDataStream because in
/// userDataStream, we can't able to use the groupid to get the groupData such as
/// groupName, createdBy, createdOn. To access the information of groupIds we have to
/// use await function, we can't use in the StreamBuilder function, so by using the
/// UserDataStream, we only get the data of groupId, not their name, createdOn,
/// createdBy. Thats why we decided to use the Provider package and do all those
/// things using this.

class GroupBoxData extends ChangeNotifier {
  List<GroupBox> _groupBoxDataList = [];
  final _firestore = FirebaseFirestore.instance;

  UnmodifiableListView getList() {
    return UnmodifiableListView(_groupBoxDataList);
  }

  int getListLength() {
    return _groupBoxDataList.length;
  }

  void clearList() {
    _groupBoxDataList.clear();
  }

  void showError(String error) {
    Fluttertoast.showToast(
      msg: error,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<bool> initialiseHomeScreen() async {
    User curUser = loggedInUser.getLoggedInUser();
    List<dynamic> groupIds = [];
    try {
      await _firestore
          .collection('users')
          .doc(curUser.uid)
          .get()
          .then((doc) => {groupIds = doc.data()['groupIds']});
      for (var groupId in groupIds) {
        groupId = groupId.toString();
        String adminName, groupName, createdOn, createdBy;
        await _firestore.collection('groups').doc(groupId).get().then((doc) => {
              groupName = doc.data()['name'],
              createdOn = doc.data()['dateCreated'],
              createdBy = doc.data()['userCreated'],
              adminName = doc.data()['adminName'],
            });
        _groupBoxDataList.insert(
            0,
            GroupBox(
              groupName: groupName,
              groupId: groupId,
              createdBy: createdBy,
              createdOn: createdOn,
              adminName: adminName,
            ));
      }
    } on FirebaseException catch (e) {
      showError(e.message);
    } catch (e) {
      showError(e.toString());
    }
    notifyListeners();
    return true;
  }

  // this will trigger on group create button and join button
  void addGroupToUser(
      {String groupId,
      String groupName,
      String createdOn,
      String createdBy,
      String adminName}) {
    _groupBoxDataList.insert(
      0,
      GroupBox(
        groupId: groupId,
        groupName: groupName,
        createdBy: createdBy,
        createdOn: createdOn,
        adminName: adminName,
      ),
    );
    notifyListeners();
  }

  void deleteGroupFromList(String groupId) {
    for (var groupBox in _groupBoxDataList) {
      if (groupBox.groupId == groupId) {
        _groupBoxDataList.remove(groupBox);
        break;
      }
    }
    notifyListeners();
  }
}
