import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masterreads/models/reviews.dart';
import 'package:masterreads/models/users.dart';

class ReviewsViewModel {
  final CollectionReference reviews =
      FirebaseFirestore.instance.collection('reviews');

  Future<bool?> addReview(Reviews review) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var validation = await firestore
          .collection('reviews')
          .where('userId', isEqualTo: review.userId)
          .where('bookId', isEqualTo: review.bookId)
          .get();

      if (validation.docs.isEmpty) {
        await reviews.doc(review.id).set(review.toMap());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getReview(String bookId) async {
    List bookReview = [];

    try {
      await reviews.where('bookId', isEqualTo: bookId).orderBy('userId').get().then((snapshot) {
        snapshot.docs.forEach((element) {
          bookReview.add(element.data());
        });
      });
      return bookReview;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getSingleRate(String bookId, String userId) async {
    List bookReview = [];

    try {
      await reviews
          .where('bookId', isEqualTo: bookId)
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) {
          bookReview.add(element.data());
        });
      });
      return bookReview;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
