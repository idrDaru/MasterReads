import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:masterreads/models/users.dart';
import 'bookTags.dart';

class Book {
  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Book({
    this.sellerId,
    this.isVerified,
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.author,
    @required this.pdfUrl,
    @required this.coverPhotoUrl,
    @required this.language,
    @required this.pages,
    @required this.description,
    @required this.dateTime,
  });

  final String? sellerId;
  final String? id;
  final String? title;
  final num? price;
  final String? author;
  final String? pdfUrl;
  final String? coverPhotoUrl;
  final String? language;
  final int? pages;
  final String? description;
  final bool? isVerified;
  final DateTime? dateTime;

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      sellerId: map['sellerId'],
      title: map['title'],
      price: map['price'],
      author: map['author'],
      pdfUrl: map['pdfUrl'],
      coverPhotoUrl: map['coverPhotoUrl'],
      language: map['language'],
      pages: map['pages'],
      description: map['description'],
      isVerified: map['isVerified'],
      dateTime: map['dateTime'],
    );
  }

  factory Book.fromFirestore(dynamic book) {
    return Book(
      id: book.get('id'),
      // id: book.get('id'),
      sellerId: book.get('sellerId'),
      title: book.get('title'),
      price: book.get('price'),
      author: book.get('author'),
      coverPhotoUrl: book.get('coverPhotoUrl'),
      language: book.get('language'),
      pdfUrl: book.get('pdfUrl'),
      pages: book.get('pages'),
      description: book.get('description'),
      isVerified: book.get('isVerified'),
      dateTime: DateTime.parse(book.get('dateTime')),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': FirebaseFirestore.instance.collection('books').doc().id,
      'sellerId': sellerId,
      'title': title,
      'price': price,
      'author': author,
      'pdfUrl': pdfUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'language': language,
      'pages': pages,
      'description': description,
      'isVerified': false,
      'dateTime': dateTime!.toIso8601String(),
    };
  }

  Map<String, dynamic> update() {
    return <String, dynamic>{
      'title': title,
      'price': price,
      'author': author,
      'language': language,
      'pages': pages,
      'description': description,
      'dateTime': dateTime!.toIso8601String(),
    };
  }

  Future getSellerBooks(String sellerId) async {
    List sellerBooks = [];
    try {
      await books.where('sellerId', isEqualTo: sellerId).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          sellerBooks.add(element.data());
        });
      });
      print(sellerBooks);
      return sellerBooks;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUserBooks() async {
    List user = await eUserModel().getCurrentUser();
    if (user[0]['role'] == 'buyer') {
      return getLibrary(user[0]['uid']);
    } else if (user[0]['role'] == 'seller') {
      return getSellerBooks(user[0]['uid']);
    }
    return null;
  }

  Future getBookList() async {
    List bookList = [];
    try {
      await books.where('isVerified', isEqualTo: true).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          bookList.add(element.data());
        });
      });
      print(bookList);
      return bookList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getBookDetail(String sellerId, String bookId) async {
    List sellerBooks = [];
    try {
      await books
          .where('sellerId', isEqualTo: sellerId)
          .where('id', isEqualTo: bookId)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((element) {
          sellerBooks.add(element.data());
        });
      });
      return sellerBooks;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getLibrary(String buyerId) async {
    List userLibrary = [];

    dynamic data = await BookTags().getPurchasedBook(buyerId);

    try {
      await books.where('id', whereIn: data).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          userLibrary.add(element.data());
        });
      });

      return userLibrary;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteBook(String bookId) async {
    await books.doc(bookId).delete();
  }

  Future getBookWillEdited(String bookId) async {
    List bookDetail = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection('books')
        .where('id', isEqualTo: bookId)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        bookDetail.add(element.data());
      });
    });

    return bookDetail;
  }
}
