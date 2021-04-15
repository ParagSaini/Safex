import 'package:firebase_auth/firebase_auth.dart';

class LoggedInUser {
  User _loggedInUser;

  LoggedInUser() {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser.emailVerified) {
      _loggedInUser = FirebaseAuth.instance.currentUser;
    }
  }
  bool isUserNull() {
    if (_loggedInUser == null) return true;
    return false;
  }

  User getLoggedInUser() {
    if (_loggedInUser != null) return _loggedInUser;
    return null;
  }

  void setLoggedInUser(User user) {
    _loggedInUser = user;
  }

  void signOutUser() {
    _loggedInUser = null;
  }
}
