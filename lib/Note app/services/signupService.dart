import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newfireabse/Note%20app/Pages/LoginScreen.dart';

signUpUser(
  String userName,
  String userPhone,
  String userEmail,
  String userPassword,
) async {
  User? UserID = FirebaseAuth.instance.currentUser;

  try {
    FirebaseFirestore.instance.collection("users").doc(UserID!.uid).set({
      "userName": userName,
      "userPhone": userPhone,
      "userEmail": userEmail,
      "userPass": userPassword,
      "createdDate": DateTime.now(),
      "userID": UserID.uid,
    }).then((value) =>
        {FirebaseAuth.instance.signOut(), Get.to(() => LoginScreen())});
  } on FirebaseAuthException catch (e) {
    print("Error $e");
  }
}
