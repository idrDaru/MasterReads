import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:masterreads/Service/authentication.dart';
import 'package:masterreads/models/bookTags.dart';
import 'package:masterreads/views/Admin/adminHomepage.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/views/books/home_screen/components/library.dart';
import 'package:masterreads/views/books/home_screen/components/userLibrary.dart';
import 'package:masterreads/views/user/buyerCart.dart';
import 'package:masterreads/views/user/cartVM.dart';
import 'package:provider/provider.dart';
double cost=4;
double amount=1;
String bookID='';
String id='';
Cart cart= new Cart();
Future<void> payment(double amount, String bookID) async {
  cost= amount;


  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
  "pk_test_51L7gEWHCNwHv6amdoazGLKNAE80S8wJcwcBLLqTpyrMyAB8UUVVTjrPRygbd89a3REo6Mwu735CVLBWYNzZ0Myuj00pClhmSwT";
  await Stripe.instance.applySettings();
  setpayment(amount, bookID);

  StripePay(amount: amount, bookID: bookID);
}

Future<void> setpayment(double amount, String bookID) async {
  cost= amount;

  id=bookID;
  print(" payment function Working");
  print("THE AMOUNT");


}

String getID()  {
  return id;


}

double getpayment()  {
  print(cost);

  return cost;

}
double a=0;

class StripePay extends StatefulWidget {
  final double amount;
  String bookID;
  StripePay({Key? key, required this.amount, required this.bookID}) : super(key: key);


  @override


  State<StripePay> createState() => _StripePayState();

}

class _StripePayState extends State<StripePay> {
  _StripePayState();
  //
  // double get amount => 0;
  //
  // String get bookID => 'null';



  @override
  void initState() {
    super.initState();
    setpayment(amount, bookID);
    payment(amount, bookID);
  }

  @override
  Widget build(BuildContext context) {


    Future<void> initPaymentSheet(context, {required String bookID,required String email, required double amount}) async {
      try {
        // 1. create payment intent on the server
        final response = await http.post(
            Uri.parse(
                'https://us-central1-masterreads-c40b2.cloudfunctions.net/stripePaymentIntentRequest'),
            body: {
              'email': email,
              'amount': amount.toString(),
            });


        final jsonResponse = jsonDecode(response.body);
        log(jsonResponse.toString());

        //2. initialize the payment sheet
        await Stripe.instance.initPaymentSheet(

          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: jsonResponse['paymentIntent'],
            merchantDisplayName: 'Flutter Stripe Store Demo',
            customerId: jsonResponse['customer'],
            customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
            style: ThemeMode.light,
            testEnv: true,
            merchantCountryCode: 'USD',
          ),
        );

        await Stripe.instance.presentPaymentSheet();


        // String buyerID= context
        //     .read<AuthService>()
        //     .getCurrentEmail() as String;
        // String bID= getID();
        //
        //
        //
        // BookTags tags= new BookTags();
        // tags.bookId=bID;
        // tags.buyerId=buyerID;
        // tags.isPurchased= true;
        //
        // var firebaseuser = await FirebaseAuth.instance.currentUser;
        //
        // FirebaseFirestore.instance
        //     .collection("bookTags")
        //     .doc(tags.tagID)
        //     .set(tags.toMap());



        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment completed!')),

          //   {this.paymentid,  this.bookid, this.uid, this.email, this.amount, });


          // cart.removeAt(index);
          //
          //
          // _delete(
          // firebaseData[index]
          // ['id']);
          //
          // Fluttertoast.showToast(
          // msg:
          // "Book Deleted successfully",
          // toastLength:
          // Toast.LENGTH_LONG,
          // );


        );
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => eLibrary(bookid:bookID)));

      } catch (e) {
        if (e is StripeException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error from Stripe: ${e.error.localizedMessage}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }

    return Scaffold(


      appBar: AppBar(
        leading: IconButton (icon:Icon(Icons.arrow_back),
            onPressed:()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Cart()));
            })
        ,
        title: const Text("Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {


                  String emailAddress= context
                      .read<AuthService>()
                      .getCurrentEmail() as String;


                  await initPaymentSheet(context, bookID: getID(),email: emailAddress, amount: getpayment()*100);


                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.purple.shade600),
                ),

                child:Container(
                  width: 300,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/images/stripe.jpeg'),
                        height: 40,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        'Pay',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )

            ),


          ],
        ),
      ),
    );
  }
}
