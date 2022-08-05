import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/viewModel/bookTagsViewModel.dart';
import 'package:masterreads/viewModel/bookViewModel.dart';
import 'package:masterreads/views/login/login_screen.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';
import 'package:provider/provider.dart';
import 'package:masterreads/views/checkout/checkout_screen.dart';

class ShoppingCart{
  final buyerId = FirebaseAuth.instance.currentUser!;
  bool isCheckout = false;
  List bookTags = [], cart = [];



  getBookTags() async {
    dynamic data = await BookTagsViewModel().getBookTags(buyerId.uid);
    if (data == null) {
      print(failedRetrieveData);
    }
    else
       {
        bookTags = data;
      }

    getCart();
  }

   getCart() async {
    dynamic data = await BookViewModel().getCartBooks(bookTags);
     {
      cart = data;
    }


    print("cartt");
     print(cart);
  }

  List sendCart()
  {
    return cart;
  }
}