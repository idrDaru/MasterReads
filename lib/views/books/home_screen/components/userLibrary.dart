import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterreads/constants/colors.dart';

import 'package:masterreads/models/book.dart';
import 'package:masterreads/models/bookTags.dart';
import 'package:masterreads/viewModel/bookTagsViewModel.dart';
import 'package:masterreads/views/books/bookDetail.dart';
import 'package:masterreads/views/books/bookList.dart';
import 'package:masterreads/views/books/edit_book_screen/edit_book_screen.dart';
import 'package:masterreads/widgets/customTabIndicator.dart';
String bookid='';
 List bList = [];
  Future  getBooks(String bookid) async
{
  List bookList = [];


  // get().then((querySnapshot)
  await books.where('ID', isEqualTo: bookid).get().then((snapshot) {
    snapshot.docs.forEach((element) {
      bookList.add(element.data());


    });
    return bookList;
  });
}
class eLibrary extends StatefulWidget {


   eLibrary({required this.bookid, Key? key}) : super(key: key);

  final String bookid;

  @override
  State<eLibrary> createState() => _eLibraryState(bookid);
}
final CollectionReference books = FirebaseFirestore.instance.collection('books');

class _eLibraryState extends State<eLibrary> {

  _eLibraryState(String bookid);

  @override
  Widget build(BuildContext context) {
    // bList=   getBooks(bookid) as List;

   return Scaffold(

   appBar:AppBar(

   ),
   body: Container(

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
                   itemCount: bList.length,

                   itemBuilder: (context, index) {

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

                           ),
                           Padding(
                             padding:
                             const EdgeInsets.only(
                                 right: 15),

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
                                     '${bList[index]['coverPhotoUrl']}',
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
                                 '${bList[index]['title'].length > 15 ? bList[index]['title'].substring(0, 15) + '...' : bList[index]['title']}',
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
                                 '${bList[index]['author'].length > 15 ? bList[index]['author'].substring(0, 15) + '...' : bList[index]['author']}',
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
                                 bList[index]['price'] == 0
                                     ? 'FREE'
                                     : '\$'
                                     '${bList[index]['price']}',
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

      );


    //   child: ListView.builder(
    //     padding: const EdgeInsets.only(
    //       left: 25,
    //       right: 6,
    //     ),
    //     itemCount: bookList.length,
    //     physics: const BouncingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     itemBuilder: (context, index) {
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) => BookDetail(
    //                 userId: userId.uid,
    //                 bookId: bookList[index]['id'],
    //                 coverUrl: bookList[index]['coverPhotoUrl'],
    //                 title: bookList[index]['title'],
    //                 author: bookList[index]['author'],
    //                 price: bookList[index]['price'].toString(),
    //                 description: bookList[index]['description'],
    //                 pdfUrl:  bookList[index]['pdfUrl'],
    //
    //               ),
    //             ),
    //           );
    //         },
    //         child: Container(
    //           margin: const EdgeInsets.only(right: 19),
    //           height: 210,
    //           width: 153,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             color: kPrimaryColor,
    //             image: DecorationImage(
    //               image: NetworkImage(
    //                 '${bookList[index]['coverPhotoUrl']}',
    //               ),
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // ),
  }
}
