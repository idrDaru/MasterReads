import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/models/bookTags.dart';
import 'package:masterreads/views/books/bookDetail.dart';


class PaymentModel{

  static String? userUid;
  final CollectionReference payment =
  FirebaseFirestore.instance.collection('payment');



  Future getUserPayments (String userId) async
  {
    List paymentList = [];
    try {
      await payment
          .where('uid', isEqualTo: userId)

          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) async {
          paymentList.add(element.data());
        });
      });
      return paymentList;
    } catch (e) {
      print(e.toString());
      return null;
    }

  }



  Future getAllPayments () async
  {
    List paymentList = [];
    try {
      await payment

          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) async {
          paymentList.add(element.data());
        });
      });
      return paymentList;
    } catch (e) {
      print(e.toString());
      return null;
    }

  }
}


