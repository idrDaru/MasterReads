
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:masterreads/viewModel/bookViewModel.dart';
import 'package:masterreads/viewModel/paymentViewModel.dart';


import '../../constants/text.dart';
import '../navigation/navigationBuyer.dart';
import '../navigation/navigationSeller.dart';
import 'SalesMonth.dart';
class SalesView extends StatefulWidget {
  SalesView({Key? key}) : super(key: key);



  final Stream<QuerySnapshot> payments =
  FirebaseFirestore.instance.collection('payment').snapshots();

  final Stream<QuerySnapshot> books =
  FirebaseFirestore.instance.collection('books').snapshots();
  double paymAmount=0;

  @override
  State<SalesView> createState() => _SalesViewState();
}


class _SalesViewState extends State<SalesView> {
  List paymentList = [];
  List salesList = [];
  String id = '';
  String dropdownvalue = 'January';


  // List of items in our dropdown menu
  var items = [
  'January',
  'February',
  'March',
  'April',
  'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',

  ];
  @override
  void initState() {
    super.initState();
    getAllPayments();
  }

  getAllPayments() async {


    dynamic data = await PaymentModel().getAllPayments();
    if (data == null) {
      print(failedRetrieveData);
    } else {
      setState(() {
        paymentList = data;
      });
      print(paymentList);
      data=null;
      getSellerPayments();
      // getBuyers();

    }
  }

List paymentMonth=[];
  getSalesbyMonth(String dropdownvalue)
  {
    String equivalent='';
    if(dropdownvalue=="January")
      {
        equivalent="01";
      }

    if(dropdownvalue=="February")
    {
      equivalent="02";
    }

    if(dropdownvalue=="March")
    {
      equivalent="03";
    }

    if(dropdownvalue=="April")
    {
      equivalent="04";
    }

    if(dropdownvalue=="May")
    {
      equivalent="05";
    }

    if(dropdownvalue=="June")
    {
      equivalent="06";
    }

    if(dropdownvalue=="July")
    {
      equivalent="07";
    }
    for(int i=0; i<paymentList.length; i++)
      {
       String date= paymentList[i]['date'].toString();
       date= date.substring(5,7);
       if (date==equivalent)
         {
           paymentMonth.add(paymentList[i]);
         }
       print("====");


      }

    Navigator.push(context, MaterialPageRoute(builder: (_) => salesMonth(paymentList: paymentMonth)));
    print(paymentMonth);
  }
  getSellerPayments() async
  {
    var user = await FirebaseAuth.instance.currentUser;


    for(int i=0; i<paymentList.length; i++)
    {
      String id = paymentList[i]['bookid'];
      print("id:");
      print(id);
      dynamic data = await BookViewModel().getSellerPay(id, user!.uid);
      print("this data:");
      print(data);


      if (data == null) {
        print(failedRetrieveData);
      } else {
        setState(() {

          salesList.add(data);

        });


      }
      // print("data: ");
      // print(data);


    }
    List numbers=[];
    print("ultimate test");
for(int i=0; i<salesList.length; i++)
  {
    if(salesList[i].toString()=="[]")
      {
        salesList.removeAt(i);
        numbers.add(i);
      }

  }

for(int i=0; i<numbers.length; i++)
  {
    print(numbers[i].toString());
  }

for(int i=0; i<paymentList.length;i++)
  {
    for(int j=0; j<numbers.length; j++)
      {
        paymentList.removeAt(numbers[j]);

      }
    break;

  }


    print("bookList length");
    print(salesList.length);
    print("booklist");
    print(salesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationSellerDrawerWidget(),
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
                  "Sales",
                  // 'Title',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                 Text(
                  // "Total Sales",
                  // 'Title',
                    salesList.length.toString() as String,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

            DropdownButton(

              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
                getSalesbyMonth(dropdownvalue);

              }),
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

                      return Card(



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

                              Container(
                                height: 50,
                                width: 50,

                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      5),
                                  image: const DecorationImage(
                                    // height: 400,
                                    // width: 250,
                                      image: AssetImage(
                                    'assets/images/user.png',
                                      ),


                                      fit: BoxFit.cover),

                                ),


                              ),

                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                children: <Widget>[

                                // give it width

                                  // const Padding(
                                  //   padding:
                                  //   EdgeInsets.only(
                                  //     right: 0,
                                  //     left: 0,
                                  //   ),
                                  //
                                  // ),
                                  // const Padding(
                                  //   padding:
                                  //   EdgeInsets.only(
                                  //       right: 0),
                                  //
                                  //
                                  // ),
                                       const Text(

                                        "elinor aluge",

                                        // 'Title',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                  SizedBox(width: 100),
                                      Text(
                                        "RM"
                                            '${paymentList[index]['amount']}',

                                        // 'Title',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: Colors.purple,
                                        ),
                                      ),


                                    ]),
                                    // Text(
                                    //
                                    //   // '${salesList[0]['title']}',
                                    //   // 'Title',
                                    //   style: const TextStyle(
                                    //     fontFamily: 'Poppins',
                                    //     fontSize: 13,
                                    //     fontWeight:
                                    //     FontWeight.w400,
                                    //     color: Colors.black,
                                    //   ),
                                    // ),

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


                      // }));
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


