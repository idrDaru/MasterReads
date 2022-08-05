
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/viewModel/bookViewModel.dart';
import 'package:masterreads/viewModel/paymentViewModel.dart';


import '../../constants/text.dart';
import '../navigation/navigationBuyer.dart';
class eLibrary extends StatefulWidget {
  eLibrary({Key? key}) : super(key: key);



  final Stream<QuerySnapshot> payments =
  FirebaseFirestore.instance.collection('payment').snapshots();

  final Stream<QuerySnapshot> books =
  FirebaseFirestore.instance.collection('books').snapshots();
  double paymAmount=0;

  @override
  State<eLibrary> createState() => _eLibraryState();
}


class _eLibraryState extends State<eLibrary> {
  List paymentList = [];
  List bookList = [];
  String id = '';

  @override
  void initState() {
    super.initState();
    getPayments();
  }

  getPayments() async {
    var user = await FirebaseAuth.instance.currentUser;


    dynamic data = await PaymentModel().getUserPayments(user!.uid);
    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        paymentList = data;
      });
      print(paymentList);
      data=null;
      getBooks();

    }
  }

  getBooks() async
  {
    List b=[];
    dynamic data;
    final CollectionReference books =
    FirebaseFirestore.instance.collection('books');
    for (int index = 0; index < paymentList.length; index++) {
      data= await books
          .where('id', isEqualTo: paymentList[index]['bookid'])
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) {
          b.add(element.data());
        });
      });
    }
    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        bookList = data;
      });
    }
    // for (int i = 0; i < paymentList.length; i++) {
    //   id = paymentList[i]['bookid'];
    //
    //    dynamic data = await BookViewModel().getBookInfo(id);
    //   // print("id: ");
    //   // print(id);
    //   // print("data=");
    //   // print (data);
    //
    //    // bookList.add(data);

    //
    // }

    print("booklist");
    print(bookList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationBuyerDrawerWidget(),
      appBar: AppBar(
          backgroundColor: Colors.white70,
          title: const Text("MasterEreads")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 5.0, vertical: 25),
          child:Container(

            child: Column(
              children: [

                const Text(
                  "Purchase History",
                  // 'Title',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                ListView.builder(

                    padding: const EdgeInsets.only(
                      top: 25,
                      right: 25,
                      left: 0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: paymentList.length,


                    itemBuilder: (context, index) {
                      int i=0;
                      var payAmount = double.parse(
                          '${paymentList[index]['amount']}');
                      id = '${paymentList[index]['id']}';

                      return Container(

                          child:ListView.builder(

                              padding: const EdgeInsets.only(
                                top: 25,
                                right: 25,
                                left: 0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: bookList.length,

                              itemBuilder: (context, counter) {

                                return Container(



                                  child: Row(
                                      children: <Widget>[
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(
                                            right: 0,
                                            left: 0,
                                          ),

                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(
                                              right: 15),


                                        ),

                                        // Container(
                                        //  height: 101,
                                        //  width: 102,
                                        //
                                        //  decoration: BoxDecoration(
                                        //    borderRadius:
                                        //    BorderRadius.circular(
                                        //        5),
                                        //    image: DecorationImage(
                                        //      // height: 400,
                                        //      // width: 250,
                                        //        image: NetworkImage(
                                        //          '${bookList[index]['coverPhotoUrl']}',
                                        //
                                        //
                                        //
                                        //        ),
                                        //
                                        //
                                        //        fit: BoxFit.fill),
                                        //
                                        //  ),
                                        //   child: Text(
                                        //
                                        //  '${bookList[counter]['id']}',
                                        //
                                        //     // 'Title',
                                        //     style: const TextStyle(
                                        //       fontFamily: 'Poppins',
                                        //       fontSize: 15,
                                        //       fontWeight:
                                        //       FontWeight.w500,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        //
                                        //  ),

                                        Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "RM"
                                                    '${paymentList[index]['amount']}',
                                                // 'Title',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),


                                              Text(

                                                '${paymentList[index]['date']}',
                                                // 'Title',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 13,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),

                                            ],
                                          ),
                                        ),
                                      ]),
                                );


                              }));
                    }

                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}


