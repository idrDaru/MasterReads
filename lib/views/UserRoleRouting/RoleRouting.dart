import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebasetest/screens/adminscreen.dart';
// import 'package:firebasetest/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/routes/routes.dart';
import 'package:masterreads/views/Admin/adminHomepage.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/Service/authentication.dart';
import 'package:provider/provider.dart';
import 'package:snap/snap.dart';
import 'package:masterreads/screens/book_details_screen/book_details_screen.dart';
import 'package:masterreads/views/books/bookDetail.dart';

import '../books/sellerHome.dart';

class RoleRouting extends StatefulWidget {
  const RoleRouting({Key? key}) : super(key: key);
  @override
  State<RoleRouting> createState() => _RoleRouting();
}

class _RoleRouting extends State<RoleRouting> with TickerProviderStateMixin {
  String role = 'buyer';
  late AnimationController controller;
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app.";

  final String DynamicLink = 'lib/views/user/books/bookDetailn';
  final String Link = 'https://masterreads.page.link/Sohr';

  @override
  void initState() {
    super.initState();
    _checkRole();
    initDynamicLinks();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    print("This id:");
    print(user?.uid);
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get();
    setState(() {
      role = snapshot.docs[0]['role'];
      // role=snap[role];
    });

    if(role=="seller")
      {
        navigateNext(sellerHome());
      }
   else  if (role == 'buyer') {
      navigateNext(BookList());
    } else if (role == 'admin') {
      navigateNext(adminHomePage());
    }
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://masterreads.page.link/Sohr',
      longDynamicLink: Uri.parse(
        'https://masterreads.page.link/?link=https://play.google.com/store/apps/details?id%3Dcom.ss.android.ugc.trill&apn=com.example.masterreads',
      ),
      link: Uri.parse(DynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 300), () {
      // Navigator.pushNamed(context, AppRoutes.routeBookDetail);
      Navigator.push(context, MaterialPageRoute(builder: (_) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'Loading',
              style: TextStyle(fontSize: 20),
            ),
            LinearProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Loading',
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text('Welcome'),
    //
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             ElevatedButton(
    //                 onPressed: () {
    //
    //                   context.read<AuthService>().signOut();
    //                 },
    //                 child: Text("Sign Out"))
    //           ],
    //         ),
    //       ],
    //     ),
    //
    //   ),
    // );
  }
}
