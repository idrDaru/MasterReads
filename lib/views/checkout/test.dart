import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:masterreads/views/Admin/adminHomepage.dart';
import 'package:masterreads/views/navigation/navigationBuyer.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/views/books/home_screen/components/library.dart';
import 'package:masterreads/views/books/home_screen/components/userLibrary.dart';
import 'package:masterreads/views/user/buyerCart.dart';
import 'package:masterreads/views/user/cartVM.dart';
class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  void initState() {
    super.initState();
    print("init state is working");
    // payment(amount, bookID);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        leading: IconButton (icon:Icon(Icons.arrow_back),
            onPressed:()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BookList()));
            })
        ,
        title: const Text("Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: ()  {
                  // lets assume that product price is 5.99 usd
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const PaypalPayment(
                  //         amount: 5.99,
                  //         currency: 'USD',
                  //       ),
                  //     ));
                  // double cost=30;


                  // await initPaymentSheet(context, email: "example@gmail.com", amount: getpayment()*100, bookID: getID());

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => payment()
                  //     // PaypalPayment(
                  //     //   onFinish: (number) async {
                  //     //     // payment done
                  //     //     print('order id: ' + number);
                  //     //   },
                  //     // ),
                  //   ),
                  // );
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

            // ElevatedButton(
            //   style: ButtonStyle(
            //     foregroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade400),
            //   ),
            //   onPressed: () async {
            //     await initPaymentSheet(context, email: "example@gmail.com", amount: 200000);
            //   },
            //   child: const Text(
            //     'pay',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
