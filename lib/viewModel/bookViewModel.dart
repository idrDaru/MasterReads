import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

class BookViewModel {
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Future getCartBooks(List bookTags) async {
    try {
      List bookList = [];
      try {
        for (int index = 0; index < bookTags.length; index++) {
          await books
              .where('id', isEqualTo: bookTags[index]['bookId'])
              .get()
              .then((snapshot) {
            snapshot.docs.forEach((element) {
              bookList.add(element.data());
            });
          });
        }
        print(bookList);
        return bookList;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future getBookInfo (String bookid) async
  {
    List bookList = [];
    try {
      await books
          .where('id', isEqualTo: bookid)

          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) async {
          bookList.add(element.data());
        });
      });
      // print("booklist in bookview");
      // print(bookList.toString());
      return bookList;
    } catch (e) {
      print(e.toString());
      return null;
    }

  }

  Future getSellerPay (String bookid, String sellerId) async
  {
    List bookList = [];
    try {
      await books
          .where('id', isEqualTo: bookid)
          .where('sellerId', isEqualTo:sellerId)

          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) async {

          // print("booklist in bookview");
         // print(element);
          bookList.add(element.data());

        });
      });


      return bookList;
    } catch (e) {
      print(e.toString());
      return null;
    }

  }
}
