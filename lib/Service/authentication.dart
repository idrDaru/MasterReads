import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterreads/models/users.dart';
import 'package:masterreads/views/home/welcomePage.dart';
import 'package:masterreads/views/user/profilePage.dart';
import 'package:masterreads/views/signUp/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../views/login/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final signup = const RegisterPage(title: "signup");
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final FirebaseAuth _firebaseAuth;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthService(this._firebaseAuth);
  //Auth change user stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Auth user sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();

  }

  //Register with email and password
  // ignore: non_constant_identifier_names
  Future RegisterWithEmail(String email, String password,
      final firstNameController, final secondNameController, String role) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? ebookUser = credentials.user;
      postDetailsToFirestore(firstNameController, secondNameController, role);
      return ebookUser;
    } catch (e) {
      print("an error occured");
      return null;
    }
  }

//lOGIN WITH EMAIL AND PASSWORD
  // ignore: non_constant_identifier_names
  Future SignInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return Fluttertoast.showToast(
        msg:
            "The user credentials entered are not correct. \nEnsure you enter the correct details",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<User?> signInWithGoogle() async {
    // final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser =
        (await _googleSignIn.signInOption) as GoogleSignInAccount?;
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final User? user = (await _auth.signInWithCredential(credential)).user;
    print("signed in ");
    return user;
  }

  Future<eUserModel> getUser() async {
    var User = await _auth.currentUser;
    return eUserModel();
  }

  postDetailsToFirestore(
      final firstNameController, final secondNameController, String role) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    eUserModel userModel = eUserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = secondNameController.text;
    userModel.role= role;

    var firebaseuser = await FirebaseAuth.instance.currentUser;
    // await firebaseFirestore
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }

  Future<String> getCurrentUID() async {
    return (await _auth.currentUser!).uid;
  }

   getCurrentEmail() async {
    return (await _auth.currentUser!).email;
  }

  Future getAuthUser() async {
    return await _auth.currentUser;
  }


  Future getUsersList() async {
    List itemsList = [];

    try {
      await users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
