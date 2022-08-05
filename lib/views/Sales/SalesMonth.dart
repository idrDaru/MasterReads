import 'package:flutter/material.dart';

import '../navigation/navigationSeller.dart';
List paymentList=[];

class salesMonth extends StatefulWidget {



   salesMonth( {Key? key, required this.paymentList}) : super(key: key);


   final List paymentList;

  @override
  State<salesMonth> createState() => _salesMonthState();
}

class _salesMonthState extends State<salesMonth> {
  List paymentMonth=[];

  double _total=0;
  @override
  void initState() {
    super.initState();

    paymentMonth=widget.paymentList;


    for(int i=0;i<paymentMonth.length;i++)
      {
        print ("total");
        print(_total);
        _total=_total+paymentMonth[i]['amount'];


      }
    //
    _total= double.parse( _total.toStringAsFixed(3));
    print("total:");
    // print(total.toStringAsFixed(2));
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
   paymentMonth.length.toString() as String,
    style: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight:
    FontWeight.w600,
    color: Colors.black,
    ),
    ),

        Text(

        "Total Sales:"
            '${_total}'.toString(),

        // 'Title',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          fontWeight:
          FontWeight.w500,
          color: Colors.black,
        ),


      ),

    // DropdownButton(
    //
    // // Initial Value
    // value: dropdownvalue,
    //
    // // Down Arrow Icon
    // icon: const Icon(Icons.keyboard_arrow_down),
    //
    // // Array list of items
    // items: items.map((String items) {
    // return DropdownMenuItem(
    // value: items,
    // child: Text(items),
    // );
    // }).toList(),
    // // After selecting the desired option,it will
    // // change button value to selected value
    // onChanged: (String? newValue) {
    // setState(() {
    // dropdownvalue = newValue!;
    // });
    // getSalesbyMonth(dropdownvalue);
    //
    // }),
    ListView.builder(

    padding: const EdgeInsets.only(
    top: 25,
    right: 25,
    left: 0,
    ),
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    primary: false,
    itemCount: paymentMonth.length,


    itemBuilder: (context, index) {
    int i=0;
    var payAmount = double.parse(
    '${paymentMonth[index]['amount']}');


    print(payAmount);
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
    '${paymentMonth[index]['amount']}',

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

    '${paymentMonth[index]['date']}',
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





