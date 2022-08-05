import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Reviews {
  String? id;
  String? bookId;
  double? rating;
  String? review;
  String? userId;

  Reviews({
    this.bookId,
    this.id,
    this.rating,
    this.review,
    this.userId,
  });

  factory Reviews.fromMap(map) {
    return Reviews(
      id: map['id'],
      bookId: map['bookId'],
      rating: map['rating'],
      review: map['review'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'rating': rating,
      'review': review,
      'userId': userId,
    };
  }
}
