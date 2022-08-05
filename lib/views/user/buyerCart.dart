import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterreads/constants/colors.dart';
import 'package:masterreads/constants/text.dart';
import 'package:masterreads/viewModel/bookTagsViewModel.dart';
import 'package:masterreads/viewModel/bookViewModel.dart';
import 'package:masterreads/views/checkout/checkout.dart';
import 'package:masterreads/views/checkout/makePayment.dart';
import 'package:masterreads/views/checkout/test.dart';
import 'package:masterreads/views/login/login_screen.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';
import 'package:provider/provider.dart';
import 'package:masterreads/views/checkout/checkout_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final buyerId = FirebaseAuth.instance.currentUser!;
  bool isCheckout = false;
  List bookTags = [], cart = [], selectedIndex = [];

  // Getting Student all Records
  final Stream<QuerySnapshot> bookRecords =
      FirebaseFirestore.instance.collection('bookTags').snapshots();
  // For Deleting Users
  CollectionReference delBook =
      FirebaseFirestore.instance.collection('bookTags');

  Future<void> _delete(id) {
    return delBook
        .doc(id)
        .delete()
        .then((value) => print('Book Deleted Successfuly'))
        .catchError((_) => print('Something Error In Deleted Book'));
  }

  @override
  void initState() {
    super.initState();
    getBookTags();
  }

  getBookTags() async {
    dynamic data = await BookTagsViewModel().getBookTags(buyerId.uid);
    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        bookTags = data;
      });
    }
    getCart();
  }

  getCart() async {
    dynamic data = await BookViewModel().getCartBooks(bookTags);
    setState(() {
      cart = data;
    });
    print(cart);
  }

  sendCart() {
    return cart;
  }

  isCheckoutState(bool newValue, int index) {
    setState(() {
      isCheckout = newValue;
      selectedIndex[index] = index;
    });
  }

  Widget buildCheckBox() => Checkbox(
      value: isCheckout,
      onChanged: (value) {
        setState(() {
          this.isCheckout = value!;
        });
      });

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return StreamBuilder<QuerySnapshot>(
        stream: bookRecords,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something Wrong in Cart');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Storing Data
          double amount = 0;
          String bookID = '';
          final List firebaseData = [];
          snapshot.data?.docs.map((DocumentSnapshot documentSnapshot) {
            Map store = documentSnapshot.data() as Map<String, dynamic>;
            firebaseData.add(store);
            store['id'] = documentSnapshot.id;
          }).toList();
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          final firebaseUser = context.watch<User?>();
          if (firebaseUser != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 249, 250, 255),
                        kPrimaryColor,
                      ],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                    ),
                  ),
                ),
                Scaffold(
                  drawer: NavigationBuyerDrawerWidget(),
                  appBar: AppBar(
                      backgroundColor: Colors.white70,
                      title: const Text("MasterEreads")),
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 25),
                      child: Column(
                        children: [
                          const Text(
                            'My Cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: 'Nisebuschgardens'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.75,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Stack(
                                children: [
                                  ListView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      ListView.builder(
                                        padding: const EdgeInsets.only(
                                          top: 25,
                                          right: 25,
                                          left: 0,
                                        ),
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: cart.length,
                                        itemBuilder: (context, index) {
                                          amount = double.parse(
                                              '${cart[index]['price']}');
                                          bookID = '${cart[index]['id']}';

                                          return Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 19),
                                            height: 81,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            color: Colors.white,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 0,
                                                    left: 0,
                                                  ),
                                                  child: buildCheckBox(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      cart.removeAt(index);

                                                      _delete(
                                                          firebaseData[index]
                                                              ['id']);

                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Book Deleted successfully",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove_circle),
                                                  ),
                                                ),
                                                Container(
                                                  height: 81,
                                                  width: 62,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          '${cart[index]['coverPhotoUrl']}',
                                                          // 'https://pbs.twimg.com/profile_images/1455185376876826625/s1AjSxph_400x400.jpg',
                                                        ),
                                                        fit: BoxFit.fill),
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${cart[index]['title'].length > 15 ? cart[index]['title'].substring(0, 15) + '...' : cart[index]['title']}',
                                                      // 'Title',
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '${cart[index]['author'].length > 15 ? cart[index]['author'].substring(0, 15) + '...' : cart[index]['author']}',
                                                      // '${cart[index]['author']}',
                                                      // 'Author',
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      cart[index]['price'] == 0
                                                          ? 'FREE'
                                                          : '\$'
                                                              '${cart[index]['price']}',
                                                      // 'Price',
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //
                              //           const pa()),
                              // );
                              // StripePay(amount:amount, bookID:bookID);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => StripePay(
                                          amount: amount, bookID: bookID)));
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => kPrimaryColor)),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const LoginPage(title: 'Login UI');
        });
  }
}

void talk() {
  print('hi');
}
