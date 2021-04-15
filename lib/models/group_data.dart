import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safex/components/group_member_sidesheet.dart';

class GroupData extends ChangeNotifier {
  List<GroupMemberSideSheet> _groupMembers = [];
  final _firestore = FirebaseFirestore.instance;

  void clearList() {
    _groupMembers.clear();
  }

  void showNegativeError(String error) {
    Fluttertoast.showToast(
      msg: error,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> initialiseGroupScreen(
      String groupId, BuildContext context) async {
    String uid, userName;
    List<dynamic> members;
    try {
      await _firestore.collection('groups').doc(groupId).get().then(
            (groupData) async => {
              members = groupData.data()['members'],
              for (var member in members)
                {
                  uid = member.toString(),
                  await _firestore
                      .collection('users')
                      .doc(uid)
                      .get()
                      .then((userData) => {
                            userName = userData.data()['name'],
                          }),
                  _groupMembers.insert(
                    0,
                    GroupMemberSideSheet(
                      uid: uid,
                      userName: userName,
                    ),
                  ),
                },
            },
          );
      notifyListeners();
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  UnmodifiableListView getList() {
    print(_groupMembers.length);
    return UnmodifiableListView(_groupMembers);
  }
}
