import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safex/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
// we can't use User simply because User is already defined for firebase user.

class EndUser {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void showPositiveError(String error) {
    Fluttertoast.showToast(
      msg: error,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void showNegativeError(String error) {
    Fluttertoast.showToast(
      msg: error,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> verifyEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser.sendEmailVerification();
      showPositiveError(
          'Verification link has been sent. Please verify and Login');
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  Future<bool> signOutAccount() async {
    String email = _auth.currentUser.email;
    bool isDeleteSuccess = true;
    try {
      await _firestore
          .collection('signedInAccounts')
          .doc(email)
          .delete()
          .timeout(Duration(seconds: 5), onTimeout: () {
        isDeleteSuccess = false;
        showNegativeError('Connection timed out');
      });
      return isDeleteSuccess;
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
    return false;
  }

  Future<User> loginUser(String email, String password) async {
    User loggedInUser;
    bool isAlreadySignedInOtherDevice = false;
    try {
      await _firestore
          .collection('signedInAccounts')
          .doc(email)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    isAlreadySignedInOtherDevice = true,
                  }
              });
      if (isAlreadySignedInOtherDevice) {
        showNegativeError(
            'Connection problem or this email is already signed In other Device');
        return null;
      }

      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        if (user.user.emailVerified) {
          await _firestore.collection('signedInAccounts').doc(email).set({});
          loggedInUser = user.user;
        } else {
          _auth.signOut();
          showNegativeError('Email not verified.');
        }
      }
    } on FirebaseAuthException catch (e) {
      showNegativeError(e.message);
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
    return loggedInUser;
  }

  Future<void> addUserToDatabase(
      User newUser, String name, GeoPoint pos, double accuracy) async {
    await _firestore.collection('users').doc(newUser.uid).set(
      {'name': name, 'groupIds': []},
    );
    await _firestore
        .collection('locations')
        .doc(newUser.uid)
        .set({'location': pos, 'accuracy': accuracy});
  }

  Future<void> createUserAndSendVerificationLink(String email, String password,
      String name, GeoPoint pos, double accuracy, BuildContext context) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        await newUser.user.updateProfile(displayName: name);
        await newUser.user.sendEmailVerification();
        await addUserToDatabase(newUser.user, name, pos, accuracy);
        await _auth.signOut();
        showPositiveError(
            'Verification link has been sent. Please verify and Login');
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      showNegativeError(e.message);
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  Future<void> addGroupToCurrentUser(String groupId) async {
    final curUserUid = loggedInUser.getLoggedInUser().uid;
    List<dynamic> temp = [groupId];
    try {
      await _firestore
          .collection('users')
          .doc(curUserUid)
          .update({'groupIds': FieldValue.arrayUnion(temp)});
    } on FirebaseException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }

  Future<void> forgotPassword({BuildContext context, String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showPositiveError('Password Reset link as been sent to $email');
    } on FirebaseAuthException catch (e) {
      showNegativeError(e.message);
    } catch (e) {
      showNegativeError(e.toString());
    }
  }
}
