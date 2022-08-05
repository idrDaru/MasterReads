import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:masterreads/viewModel/reviewsViewModel.dart';

class eUserModel {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? role;

  eUserModel({
    this.role,
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
  });

  // receiving data from server
  factory eUserModel.fromMap(map) {
    return eUserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      role: map['role'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'role': role,
    };
  }

  Future getDisplayName(String userId) async {
    List user = [];

    await users.where('uid', isEqualTo: userId).get().then((snapshot) {
      snapshot.docs.forEach((element) async {
        user.add(element.data());
      });
    });
    String name = "";
    for (int i = 0; i < user.length; i++) {
      name = user[i]['firstName'] + user[i]['secondName'];
    }
    print(name);
    return name;
  }

  Future getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    List currentUser = [];
    try {
      await users.where('uid', isEqualTo: user.uid).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          currentUser.add(element.data());
        });
      });
      return currentUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUserReview(List reviews) async {
    List user = [];
    List userId = [];

    for (var uid in reviews) {
      userId.add(uid['userId']);
    }
    try {
      dynamic data =
          await users.where('uid', whereIn: userId).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          user.add(element.data());
        });
      });
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
